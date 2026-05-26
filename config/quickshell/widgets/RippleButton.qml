import QtQuick

Rectangle {
    id: root

    default property alias content: contentItem.data
    property color rippleColor: "white"
    property real rippleOpacity: 0.8
    property int rippleDuration: 400

    signal clicked(var mouse)
    signal pressed(var mouse)

    clip: true

    Rectangle {
        id: ripple
        anchors.centerIn: parent
        implicitWidth: root.width
        implicitHeight: implicitWidth
        radius: width / 2
        color: root.rippleColor
        opacity: 0
        scale: 0
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }

    ParallelAnimation {
        id: rippleAnim
        NumberAnimation {
            target: ripple
            property: "scale"
            from: 0
            to: 1
            duration: root.rippleDuration
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: ripple
            property: "opacity"
            from: root.rippleOpacity
            to: 0
            duration: root.rippleDuration
            easing.type: Easing.OutQuad
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: mouse => {
            rippleAnim.restart();
            root.pressed(mouse);
        }
        onClicked: mouse => root.clicked(mouse)
    }
}
