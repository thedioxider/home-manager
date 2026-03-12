pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    property color particleColor: "white"
    property real particleRadius: 0.6
    property real particleSize: 92
    property real particleSpacing: 12

    property real particleActiveOpacity: 1.0
    property real particleInactiveOpacity: 0.0
    property int animationDuration: 250

    color: "transparent"
    surfaceFormat.opaque: false
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "binary-clock"

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    component Particle: Rectangle {
        required property int value
        required property int bit
        property bool active: (value >> bit) & 1

        implicitWidth: root.particleSize
        implicitHeight: root.particleSize
        radius: Math.min(width, height) / 2 * root.particleRadius
        color: root.particleColor
        opacity: active ? root.particleActiveOpacity : root.particleInactiveOpacity

        Behavior on opacity {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.InQuad
            }
        }
    }

    component Segment: GridLayout {
        id: seg
        property int value: 0

        rows: 3
        columns: 2
        flow: GridLayout.TopToBottom

        rowSpacing: root.particleSpacing
        columnSpacing: root.particleSpacing

        Repeater {
            model: [5, 4, 3, 2, 1, 0]
            delegate: Particle {
                required property int modelData
                value: seg.value
                bit: modelData
            }
        }
    }

    WrapperItem {
        id: content
        margin: root.particleSpacing

        RowLayout {
            id: grid
            spacing: root.particleSpacing

            Segment { value: clock.hours }
            Segment { value: clock.minutes }
            Segment { value: clock.seconds }
        }
    }

    MouseArea {
        anchors.fill: content
        hoverEnabled: true

        ToolTip {
            id: tip
            delay: 500
            visible: parent.containsMouse
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            text: Qt.formatTime(new Date(0, 0, 0, clock.hours, clock.minutes, clock.seconds), "HH:mm:ss")

            contentItem: Text {
                text: tip.text
                color: "white"
                font.family: "CaskaydiaMono Nerd Font Mono"
                font.pointSize: 32
                font.bold: true
            }

            background: Rectangle {
                color: Qt.rgba(0, 0, 0, 0.7)
                radius: 12
            }

            padding: 8
        }
    }
}
