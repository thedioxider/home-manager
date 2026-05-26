import QtQuick
import QtQuick.Shapes

// Solid bar background with concave fillets flaring outward at the top-right
// and bottom-right corners.
//
// The exposed silhouette (top flare -> right edge -> bottom flare) is defined
// once in `edgeProfile` and reused by both paths: the fill closes it across the
// screen-flush edges, the border strokes only the exposed part.
Shape {
    id: root

    required property real radius
    required property color color
    property real borderWidth: 0
    property color borderColor: "transparent"

    readonly property real r: radius
    readonly property real w: width
    readonly property real h: height

    // From the top flare point, down the two fillets and right edge, to the
    // bottom flare point. Both arcs are concave (sweep 0, minor arc).
    readonly property string edgeProfile: `A ${r} ${r} 0 0 0 ${w} ${r} L ${w} ${h - r} A ${r} ${r} 0 0 0 ${w + r} ${h}`

    preferredRendererType: Shape.CurveRenderer

    // Fill: close the silhouette back across the flush left/top/bottom edges.
    ShapePath {
        fillColor: root.color
        strokeWidth: -1
        PathSvg {
            path: `M 0 0 L ${root.w + root.r} 0 ${root.edgeProfile} L 0 ${root.h} Z`
        }
    }

    // Border: stroke only the exposed silhouette. The ends run a touch past the
    // top/bottom screen edges so the caps fall off-screen and the visible stroke
    // terminates flush at the edges (no cap stubs).
    ShapePath {
        fillColor: "transparent"
        strokeColor: root.borderColor
        strokeWidth: root.borderWidth > 0 ? root.borderWidth : -1
        capStyle: ShapePath.FlatCap
        PathSvg {
            path: `M ${root.w + root.r} ${-root.borderWidth} L ${root.w + root.r} 0 ${root.edgeProfile} L ${root.w + root.r} ${root.h + root.borderWidth}`
        }
    }
}
