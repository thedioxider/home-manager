import QtQuick

Item {
    id: proxy

    required property Item target

    readonly property alias hover: hover
    readonly property alias tap: tap
    readonly property alias hovered: hover.hovered

    // Sum local positions up the parent chain. Reading each ancestor's x/y
    // registers it as a binding dependency, so this re-evaluates whenever the
    // target or any ancestor moves (unlike mapToItem, whose deps are opaque).
    readonly property point origin: {
        let x = 0;
        let y = 0;
        let item = target;
        while (item) {
            x += item.x;
            y += item.y;
            item = item.parent;
        }
        return Qt.point(x, y);
    }

    x: origin.x
    y: origin.y
    width: target.width
    height: target.height

    HoverHandler {
        id: hover
    }

    TapHandler {
        id: tap
        exclusiveSignals: TapHandler.SingleTap | TapHandler.DoubleTap
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    }
}
