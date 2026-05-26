pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell.Widgets
import qs.config
import qs.widgets
import qs.widgets.util

Item {
    id: root

    required property list<StatusCapsuleItem> entries
    required property PointerProxy pointer
    readonly property int iconBox: width
    property int drawerWidth: iconBox * 6
    property int frame: 4
    property int radius: iconBox / 2
    property real barEdge: iconBox
    property int animationDuration: 250

    property bool drawerOpen: pointer.hovered
    property real reveal: drawerOpen ? 1 : 0
    Behavior on reveal {
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.OutCubic
        }
    }

    property alias hoverArea: footprint

    implicitHeight: iconBox * entries.length

    Item {
        id: footprint
        anchors.fill: pill
        anchors.margins: -root.frame
    }

    Shape {
        id: fs

        readonly property real frameTop: -root.frame
        readonly property real frameBottom: root.height + root.frame
        readonly property real frameLeft: root.barEdge
        readonly property real frameRight: root.iconBox + root.drawerWidth * root.reveal + root.frame
        readonly property real protrusion: Math.max(0, frameRight - frameLeft)
        readonly property real radius: root.radius + root.frame
        readonly property real edgeMid: (frameLeft + frameRight) / 2
        readonly property real midLength: edgeMid - frameLeft
        readonly property real concaveEndX: midLength < radius ? edgeMid : frameLeft + radius
        readonly property real convexStartX: midLength < radius ? edgeMid : frameRight - radius
        readonly property real deltaDistance: {
            if (midLength < radius) {
                let h = radius - (edgeMid - frameLeft);
                return radius - Math.sqrt(radius * radius - h * h);
            }
            return 0;
        }

        visible: protrusion > 0
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: Theme.palette.background
            strokeWidth: -1

            startX: fs.frameLeft
            startY: fs.frameTop - fs.radius + 2 * fs.deltaDistance

            PathArc {
                x: fs.concaveEndX
                y: fs.frameTop + fs.deltaDistance
                radiusX: fs.radius
                radiusY: fs.radius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: fs.convexStartX
                y: fs.frameTop + fs.deltaDistance
            }
            PathArc {
                x: fs.frameRight
                y: fs.frameTop + fs.radius
                radiusX: fs.radius
                radiusY: fs.radius
            }
            PathLine {
                x: fs.frameRight
                y: fs.frameBottom - fs.radius
            }
            PathArc {
                x: fs.convexStartX
                y: fs.frameBottom - fs.deltaDistance
                radiusX: fs.radius
                radiusY: fs.radius
            }
            PathLine {
                x: fs.concaveEndX
                y: fs.frameBottom - fs.deltaDistance
            }
            PathArc {
                x: fs.frameLeft
                y: fs.frameBottom + fs.radius - 2 * fs.deltaDistance
                radiusX: fs.radius
                radiusY: fs.radius
                direction: PathArc.Counterclockwise
            }
        }
    }

    ClippingRectangle {
        id: pill
        width: root.iconBox + root.drawerWidth * root.reveal
        height: root.height
        radius: root.radius
        color: Theme.palette.backgroundAlt

        Column {
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: root.entries
                delegate: Item {
                    id: row
                    required property var modelData
                    width: pill.width
                    height: root.iconBox

                    Item {
                        width: root.iconBox
                        height: root.iconBox

                        Loader {
                            anchors.centerIn: parent
                            sourceComponent: row.modelData.glyph
                        }
                    }

                    Item {
                        x: root.iconBox
                        width: root.drawerWidth
                        height: root.iconBox
                        visible: root.reveal > 0
                        opacity: root.reveal

                        MarqueeText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.rightMargin: root.radius
                            height: parent.height
                            backgroundColor: Theme.palette.backgroundAlt
                            delegate: row.modelData.text
                        }
                    }

                    ProxyHoverArea {
                        id: rowHover
                        anchors.fill: parent
                        proxy: root.pointer
                        active: row.modelData.action !== null
                        onClicked: row.modelData.action()
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: Theme.palette.surface
                        opacity: rowHover.hovered ? 0.4 : 0
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }
}
