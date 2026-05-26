import QtQuick
import QtQuick.Shapes

// Solid bar background with concave fillets flaring outward at the screen corners.
Shape {
    id: root

    required property real barWidth
    required property real radius
    required property color color
    property real borderWidth: 0
    property color borderColor: "transparent"

    readonly property real r: radius
    readonly property real w: width
    readonly property real bw: barWidth
    readonly property real h: height

    readonly property string shapePath: `
        M 0 0
        L ${bw + r} 0
        A ${r} ${r} 0 0 0 ${bw} ${r}
        L ${bw} ${h - r}
        A ${r} ${r} 0 0 0 ${bw + r} ${h}
        L 0 ${h}
        Z
        M ${w} 0
        L ${w - r} 0
        A ${r} ${r} 0 0 1 ${w} ${r}
        Z
        M ${w} ${h}
        L ${w - r} ${h}
        A ${r} ${r} 0 0 0 ${w} ${h - r}
        Z
    `

    preferredRendererType: Shape.CurveRenderer

    // Fill: close the silhouette back across the flush left/top/bottom edges.
    ShapePath {
        fillColor: root.color
        strokeWidth: -1
        PathSvg {
            path: root.shapePath
        }
    }
}
