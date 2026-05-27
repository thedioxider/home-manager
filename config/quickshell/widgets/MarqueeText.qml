import QtQuick

Item {
    id: root

    property Component delegate

    property color backgroundColor: "black"
    property bool play: true
    property real padding: 0
    property real speed: 32  // px/s
    property int pauseDuration: 1500  // ms held still between cycles
    property real gap: 24  // px between text repetitions
    property real fadeWidth: 18  // px

    clip: true
    implicitWidth: textWidth
    implicitHeight: primary ? primary.implicitHeight : 0

    readonly property Text primary: primaryLoader.item as Text
    readonly property real textWidth: primary ? primary.contentWidth : 0
    property bool overflows: root.width > 0 && textWidth > root.width
    readonly property real cycleDist: textWidth + gap
    readonly property int cycleMs: speed > 0 ? Math.round(cycleDist / speed * 1000) : 0

    Row {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.gap
        x: root.overflows ? root.padding : 0

        Loader {
            id: primaryLoader
            sourceComponent: root.delegate
        }
        Loader {
            active: root.overflows
            sourceComponent: root.delegate
        }

        SequentialAnimation on x {
            running: root.play && root.overflows && root.visible
            loops: Animation.Infinite
            PauseAnimation {
                duration: root.pauseDuration
            }
            NumberAnimation {
                from: root.padding
                to: root.padding - root.cycleDist
                duration: root.cycleMs
                easing.type: Easing.Linear
            }
            NumberAnimation {
                to: root.padding
                duration: 0
            }
        }
    }

    Rectangle {
        visible: root.overflows && track.x - root.padding < 0
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: root.fadeWidth
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: root.backgroundColor
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }

    Rectangle {
        visible: root.overflows
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: root.fadeWidth
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 1.0
                color: root.backgroundColor
            }
        }
    }
}
