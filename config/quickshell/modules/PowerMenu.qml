pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.state

PanelWindow {
    id: root

    visible: PowerMenuState.activeScreen !== null
    focusable: PowerMenuState.activeScreen === screen

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "power-menu"

    anchors { left: true; top: true; right: true; bottom: true }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    onFocusableChanged: if (focusable) power1.forceActiveFocus()

    component PowerButton: ClippingWrapperRectangle {
        id: powerButton
        required property string icon
        required property string label

        signal click

        Layout.fillHeight: true
        Layout.fillWidth: true
        implicitWidth: height
        radius: 48
        color: "transparent"
        border.color: Theme.palette.surface
        border.width: 4

        Keys.onReturnPressed: { PowerMenuState.close(); powerButton.click(); }
        Keys.onSpacePressed: { PowerMenuState.close(); powerButton.click(); }
        Keys.onEscapePressed: PowerMenuState.close()

        Item {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: Theme.palette.background
                opacity: 0.5
            }

            Column {
                anchors.centerIn: parent
                spacing: 16

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
                opacity: powerButton.activeFocus ? 0.2 : 0
                Behavior on opacity {
                    NumberAnimation { duration: 200; easing: Easing.OutCubic }
                }
            }
        }

        HoverHandler {
            onHoveredChanged: if (hovered) powerButton.forceActiveFocus()
        }
        TapHandler {
            onTapped: { PowerMenuState.close(); powerButton.click(); }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: PowerMenuState.activeScreen !== null ? 0.45 : 0
        Behavior on opacity {
            NumberAnimation { duration: 120; easing: Easing.OutCubic }
        }
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 60
        height: 300
        visible: PowerMenuState.activeScreen === root.screen
        opacity: PowerMenuState.activeScreen === root.screen ? 1 : 0
        scale: PowerMenuState.activeScreen === root.screen ? 1 : 0.93
        Behavior on opacity { NumberAnimation { duration: 160; easing: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 160; easing: Easing.OutCubic } }

        PowerButton {
            id: power1
            icon: "\uf023"
            label: "Lock"
            onClick: Quickshell.execDetached(["loginctl", "lock-session"])
            KeyNavigation.left: power3
            KeyNavigation.right: power2
        }
        PowerButton {
            id: power2
            icon: "\uf011"
            label: "Power Off"
            onClick: Hyprland.dispatch("hl.dsp.exec_cmd(\"hyprshutdown --post-cmd 'systemctl poweroff'\")")
            KeyNavigation.left: power1
            KeyNavigation.right: power3
        }
        PowerButton {
            id: power3
            icon: "\uf021"
            label: "Reboot"
            onClick: Hyprland.dispatch("hl.dsp.exec_cmd(\"hyprshutdown --post-cmd 'systemctl reboot'\")")
            KeyNavigation.left: power2
            KeyNavigation.right: power1
        }
    }

    TapHandler {
        onTapped: PowerMenuState.close()
    }
}
