pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell.Widgets
import qs.config
import qs.widgets.util

Item {
    id: root

    required property list<StatusCapsuleItem> entries
    required property PointerProxy pointer
    readonly property int iconBox: width
    property int maxDrawerWidth: iconBox * 6
    property int frame: 4
    property int radius: iconBox / 2
    property real barEdge: iconBox
    property int animationDuration: 250

    readonly property real drawerWidth: Math.min(maxDrawerWidth, contentWidths.max + radius)

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

    MaxAggregator {
        id: contentWidths
        count: root.entries.length
    }

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
            PathSvg {
                path: {
                    const r = fs.radius;
                    const d = fs.deltaDistance;
                    return `
                        M ${fs.frameLeft} ${fs.frameTop - r + 2 * d}
                        A ${r} ${r} 0 0 0 ${fs.concaveEndX} ${fs.frameTop + d}
                        L ${fs.convexStartX} ${fs.frameTop + d}
                        A ${r} ${r} 0 0 1 ${fs.frameRight} ${fs.frameTop + r}
                        L ${fs.frameRight} ${fs.frameBottom - r}
                        A ${r} ${r} 0 0 1 ${fs.convexStartX} ${fs.frameBottom - d}
                        L ${fs.concaveEndX} ${fs.frameBottom - d}
                        A ${r} ${r} 0 0 0 ${fs.frameLeft} ${fs.frameBottom + r - 2 * d}
                    `;
                }
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
                    required property int index
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

                        Loader {
                            id: content
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.rightMargin: root.radius
                            height: parent.height
                            sourceComponent: row.modelData.content
                            onImplicitWidthChanged: contentWidths.report(row.index, implicitWidth)
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
                        opacity: rowHover.hovered ? 0.2 : 0
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
