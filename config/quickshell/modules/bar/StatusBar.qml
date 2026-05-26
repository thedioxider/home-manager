pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.widgets
import qs.widgets.util

PanelWindow {
    id: statusBar

    readonly property int barWidth: 48
    readonly property int cornerRadius: 24

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "status-bar"

    anchors {
        left: true
        top: true
        right: true
        bottom: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    mask: Region {
        item: barContent
        Region {
            item: connectivityList.hoverArea
        }
    }

    component StatusGlyphItem: Text {
        font.family: Theme.fonts.symbols
        font.pixelSize: (statusBar.barWidth - 12) / 2
        color: Theme.palette.onBackground
    }

    component StatusTextItem: MarqueeText {
        id: marqueeText
        property string text
        delegate: Text {
            text: marqueeText.text
            font.family: Theme.fonts.text
            font.pixelSize: 14
            color: Theme.palette.onBackground
        }
    }

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    BarBackground {
        id: barBg
        anchors.fill: parent
        barWidth: statusBar.barWidth
        radius: statusBar.cornerRadius
        color: Theme.palette.background
    }

    ColumnLayout {
        id: barContent
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: statusBar.barWidth
        spacing: 0

        Item {
            Layout.fillHeight: true
        }

        StatusCapsule {
            id: connectivityList
            Layout.fillWidth: true
            Layout.margins: 6
            frame: 4
            barEdge: statusBar.barWidth - x
            pointer: connectivityListProxy

            entries: [
                StatusCapsuleItem {
                    id: netItem
                    readonly property var _net: {
                        let devs = Networking.devices.values;
                        for (var i = 0; i < devs.length; i++) {
                            let nets = devs[i].networks.values;
                            for (var j = 0; j < nets.length; j++) {
                                if (nets[j].connected)
                                    return nets[j];
                            }
                        }
                        return null;
                    }
                    glyph: StatusGlyphItem {
                        text: netItem._net ? "󰤨" : "󰤭"
                    }
                    content: StatusTextItem {
                        text: netItem._net ? netItem._net.name : "Disconnected"
                    }
                },
                StatusCapsuleItem {
                    id: btItem
                    readonly property bool _btOn: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false
                    readonly property var _connectedDev: {
                        let devs = Bluetooth.devices ? Bluetooth.devices.values : [];
                        for (var i = 0; i < devs.length; i++) {
                            if (devs[i].connected)
                                return devs[i];
                        }
                        return null;
                    }
                    glyph: StatusGlyphItem {
                        text: btItem._btOn ? (btItem._connectedDev ? "󰂱" : "󰂯") : "󰂲"
                    }
                    content: StatusTextItem {
                        text: btItem._btOn ? (btItem._connectedDev ? (btItem._connectedDev.batteryAvailable ? "[" + Math.round(btItem._connectedDev.battery * 100) + "%] " : "") + btItem._connectedDev.name : "On") : "Off"
                    }
                }
            ]
        }

        StatusCapsule {
            id: levelList
            Layout.fillWidth: true
            Layout.margins: 6
            frame: 4
            barEdge: statusBar.barWidth - x
            pointer: levelListProxy

            entries: [
                StatusCapsuleItem {
                    id: volItem
                    readonly property var _sink: Pipewire.defaultAudioSink
                    readonly property bool _muted: _sink && _sink.audio ? _sink.audio.muted : false
                    readonly property int _vol: _sink && _sink.audio ? Math.round(_sink.audio.volume * 100) : 0
                    glyph: StatusGlyphItem {
                        text: volItem._muted ? "󰝟" : volItem._vol > 66 ? "󰕾" : volItem._vol > 0 ? "󰖀" : "󰕿"
                    }
                    content: StatusTextItem {
                        text: volItem._muted ? "Muted" : volItem._vol + "%"
                    }
                    action: () => Quickshell.execDetached(["kitty", "pulsemixer"])
                },
                StatusCapsuleItem {
                    id: batItem
                    readonly property var _bat: UPower.displayDevice
                    readonly property bool _ready: _bat.ready
                    readonly property bool _charging: _ready && (_bat.state === UPowerDeviceState.Charging || _bat.state === UPowerDeviceState.FullyCharged)
                    readonly property int _pct: _ready ? Math.round(_bat.percentage * 100) : 0
                    glyph: StatusGlyphItem {
                        text: !batItem._ready ? "󰂑" : batItem._charging ? "󰂄" : batItem._pct > 90 ? "󰁹" : batItem._pct > 80 ? "󰂂" : batItem._pct > 70 ? "󰂁" : batItem._pct > 60 ? "󰂀" : batItem._pct > 50 ? "󰁿" : batItem._pct > 40 ? "󰁾" : batItem._pct > 30 ? "󰁽" : batItem._pct > 20 ? "󰁼" : batItem._pct > 10 ? "󰁻" : "󰁺"
                    }
                    content: StatusTextItem {
                        text: batItem._ready ? batItem._pct + "%" : "N/A"
                    }
                }
            ]
        }

        RippleButton {
            Layout.fillWidth: true
            Layout.margins: 6
            implicitHeight: width
            radius: width / 2
            color: Theme.palette.backgroundAlt
            rippleColor: Theme.palette.surface
            onClicked: Quickshell.execDetached(["rofi", "-show", "drun"])

            StatusGlyphItem {
                anchors.centerIn: parent
                text: ""
                color: Theme.palette.onBackground
            }
        }
    }

    // Pointer proxies, aren't cropped by parents
    PointerProxy {
        id: connectivityListProxy
        target: connectivityList.hoverArea
    }
    PointerProxy {
        id: levelListProxy
        target: levelList.hoverArea
    }

    // Separate exclusion zone, since the bar's window is full-screen
    PanelWindow {
        screen: statusBar.screen

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "status-bar-exclusion"

        anchors {
            left: true
            top: true
            bottom: true
        }

        implicitWidth: 1
        color: "transparent"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: statusBar.barWidth
        mask: Region {}
    }
}
