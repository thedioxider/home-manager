pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.widgets
import qs.widgets.util

PanelWindow {
    id: statusBar

    readonly property int barWidth: 48
    readonly property int cornerRadius: 24
    readonly property int itemMargins: 6
    readonly property int capsuleFrame: itemMargins
    readonly property HyprlandMonitor hyprMonitor: Hyprland.monitorFor(screen)

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
            item: workspacesWidget.hoverArea
        }
        Region {
            item: trayWidget.hoverArea
        }
        Region {
            item: connectivityList.hoverArea
        }
        Region {
            item: levelList.hoverArea
        }
    }

    component StatusGlyphItem: Text {
        font.family: Theme.fonts.symbols
        font.pixelSize: (statusBar.barWidth - 2 * statusBar.itemMargins) / 2
        color: Theme.palette.onBackground
    }

    component StatusTextItem: MarqueeText {
        id: marqueeText
        property string text
        backgroundColor: Theme.palette.backgroundAlt
        delegate: Text {
            text: marqueeText.text
            font.family: Theme.fonts.text
            font.pixelSize: 14
            color: Theme.palette.onBackground
        }
    }

    component ClockPieceItem: Text {
        required property string format
        text: Qt.formatTime(clock.date, format)
        fontSizeMode: Text.HorizontalFit
        font.pixelSize: statusBar.barWidth
        height: implicitWidth / 2
        anchors {
            left: clockWidget.left
            right: clockWidget.right
        }
        font.family: Theme.fonts.text
        font.bold: true
        color: Theme.palette.onBackground
    }

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
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

        Column {
            id: clockWidget
            Layout.fillWidth: true
            Layout.margins: statusBar.itemMargins * 1.2
            ClockPieceItem {
                format: "HH"
            }
            ClockPieceItem {
                format: "mm"
            }
            ClockPieceItem {
                format: "ss"
                opacity: 0.3
            }
        }

        StatusCapsule {
            id: workspacesWidget
            Layout.fillWidth: true
            Layout.margins: statusBar.itemMargins
            frame: statusBar.capsuleFrame
            barEdge: statusBar.barWidth - x
            pointer: workspacesWidgetProxy
            drawerOpen: false

            Instantiator {
                id: workspaces
                model: Hyprland.workspaces.values.filter(ws => ws.monitor == statusBar.hyprMonitor && ws.id > 0)
                delegate: StatusCapsuleItem {
                    id: workspaceItem
                    required property HyprlandWorkspace modelData
                    glyph: StatusGlyphItem {
                        text: ""
                        font.family: Theme.fonts.text
                        font.bold: true
                        font.pixelSize: statusBar.barWidth / 2
                        color: (workspaceItem.modelData && workspaceItem.modelData.active) ? Theme.palette.surface : Theme.palette.onBackground
                    }
                    content: StatusTextItem {
                        // text: workspaceItem.modelData && workspaceItem.modelData.toplevels.values.map(tl => tl.title).join(", ")
                        text: ""
                    }
                    action: (modelData && modelData.active) ? null : () => modelData.activate()
                }
            }
            entries: {
                let arr = [];
                for (let i = 0; i < workspaces.count; ++i)
                    arr.push(workspaces.objectAt(i));
                return arr;
            }
        }

        ClippingRectangle {
            id: windowTitle
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 6
            radius: width / 2
            color: activeWindow !== null ? Theme.palette.backgroundAlt : "transparent"

            readonly property HyprlandToplevel activeWindow: (Hyprland.activeToplevel && Hyprland.activeToplevel.workspace && Hyprland.activeToplevel.workspace.active && Hyprland.activeToplevel.monitor == statusBar.hyprMonitor) ? Hyprland.activeToplevel : null

            Item {
                visible: windowTitle.activeWindow !== null
                y: windowTitle.height
                transform: Rotation {
                    angle: -90
                }
                width: windowTitle.height
                height: windowTitle.width

                MarqueeText {
                    id: windowTitleMarquee

                    overflows: textWidth + 2 * padding > parent.width
                    width: overflows ? parent.width : textWidth
                    height: parent.height - 2 * statusBar.itemMargins
                    anchors.centerIn: parent

                    backgroundColor: Theme.palette.backgroundAlt
                    delegate: Text {
                        text: windowTitle.activeWindow && windowTitle.activeWindow.title
                        font.family: Theme.fonts.text
                        font.pixelSize: statusBar.barWidth
                        fontSizeMode: Text.VerticalFit
                        width: contentWidth
                        height: windowTitleMarquee.height
                        color: Theme.palette.onBackground
                    }

                    padding: windowTitle.radius
                    gap: windowTitle.radius + 16
                }
            }
        }

        StatusCapsule {
            id: trayWidget
            Layout.fillWidth: true
            Layout.margins: statusBar.itemMargins
            frame: statusBar.capsuleFrame
            barEdge: statusBar.barWidth - x
            pointer: trayWidgetProxy

            Instantiator {
                id: trayItems
                model: SystemTray.items
                delegate: StatusCapsuleItem {
                    id: trayItem
                    required property SystemTrayItem modelData
                    glyph: IconImage {
                        source: trayItem.modelData.icon
                        implicitSize: trayWidget.width - 2 * statusBar.itemMargins
                    }
                    content: StatusTextItem {
                        text: trayItem.modelData.title
                    }
                    action: () => trayItem.modelData.activate()
                    secondaryAction: pos => trayItem.modelData.display(statusBar, pos.x, pos.y)
                    tertiaryAction: () => trayItem.modelData.secondaryActivate()
                }
            }
            entries: {
                let arr = [];
                for (let i = 0; i < trayItems.count; ++i)
                    arr.push(trayItems.objectAt(i));
                return arr;
            }
        }

        StatusCapsule {
            id: connectivityList
            Layout.fillWidth: true
            Layout.margins: statusBar.itemMargins
            frame: statusBar.capsuleFrame
            barEdge: statusBar.barWidth - x
            pointer: connectivityListProxy

            entries: [
                StatusCapsuleItem {
                    id: netItem
                    readonly property var _net: {
                        let devs = Networking.devices.values;
                        for (var i = 0; i < devs.length; i++) {
                            let net = devs[i].networks.values.find(net => net.connected);
                            if (net)
                                return net;
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
                        let dev = (Bluetooth.devices ? Bluetooth.devices.values : []).find(dev => dev.connected);
                        if (dev)
                            return dev;
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
            Layout.margins: statusBar.itemMargins
            frame: statusBar.capsuleFrame
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
            Layout.margins: statusBar.itemMargins
            implicitHeight: width
            radius: width / 2
            color: Theme.palette.backgroundAlt
            rippleColor: Theme.palette.surface
            onClicked: powerMenuScreen.visible = !powerMenuScreen.visible

            StatusGlyphItem {
                anchors.centerIn: parent
                text: ""
                color: Theme.palette.onBackground
            }
        }
    }

    // Pointer proxies, aren't cropped by parents
    PointerProxy {
        id: workspacesWidgetProxy
        target: workspacesWidget.hoverArea
    }
    PointerProxy {
        id: trayWidgetProxy
        target: trayWidget.hoverArea
    }
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

    component PowerButton: ClippingWrapperRectangle {
        id: powerButton
        required property string icon
        required property string label

        signal click

        focus: hover.hovered

        Layout.fillHeight: true
        Layout.fillWidth: true
        border {
            color: Theme.palette.surface
            width: 4
        }
        color: "transparent"
        radius: 48
        implicitWidth: height

        Item {
            Rectangle {
                anchors.fill: parent
                color: Theme.palette.background
                opacity: 0.5
            }

            Column {
                spacing: 16
                anchors.centerIn: parent
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: powerButton.icon
                    font.family: Theme.fonts.symbols
                    font.pixelSize: powerButton.height / 3
                    color: Theme.palette.onBackground
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: powerButton.label
                    font.family: Theme.fonts.text
                    font.pixelSize: 36
                    color: Theme.palette.onBackground
                }
            }
            Rectangle {
                anchors.fill: parent
                color: Theme.palette.surface
                opacity: powerButton.focus ? 0.2 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing: Easing.OutCubic
                    }
                }
            }
        }
        HoverHandler {
            id: hover
        }
        TapHandler {
            onTapped: {
                powerMenuScreen.visible = false;
                powerButton.click();
            }
        }
    }

    PanelWindow {
        id: powerMenuScreen
        screen: statusBar.screen
        visible: false
        focusable: true

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "status-bar-power"

        anchors {
            left: true
            top: true
            right: true
            bottom: true
        }

        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        RowLayout {
            anchors.centerIn: parent
            spacing: 60
            height: 300

            PowerButton {
                id: power1
                icon: ""
                label: "Lock"
                onClick: Quickshell.execDetached(["loginctl", "lock-session"])
                KeyNavigation.left: power3
                KeyNavigation.right: power2
            }
            PowerButton {
                id: power2
                icon: ""
                label: "Power Off"
                onClick: Quickshell.execDetached(["hyprshutdown", "--post-cmd", "'poweroff'"])
                KeyNavigation.left: power1
                KeyNavigation.right: power3
            }
            PowerButton {
                id: power3
                icon: ""
                label: "Reboot"
                onClick: Quickshell.execDetached(["hyprshutdown", "--post-cmd", "'reboot'"])
                KeyNavigation.left: power2
                KeyNavigation.right: power1
            }
        }
        TapHandler {
            onTapped: powerMenuScreen.visible = false
        }
        KeyNavigation.left: power3
        KeyNavigation.right: power1
    }
}
