import QtQuick
import qs.widgets.util

Item {
    id: area

    required property PointerProxy proxy
    property bool active: true
    property bool useDoubleClick: false

    function toLocalPoint(point) {
        return mapFromItem(null, point.x, point.y);
    }

    signal leftClicked(point pos)
    signal rightClicked(point pos)
    signal middleClicked(point pos)
    signal doubleClicked(point pos)

    readonly property point localPointer: (active && proxy.hovered) ? toLocalPoint(proxy.hover.point.scenePosition) : null
    readonly property bool hovered: active && proxy.hovered && contains(localPointer)

    Connections {
        enabled: area.active
        target: area.proxy.hover
    }

    Connections {
        id: doubleClickConnections
        enabled: area.active && area.useDoubleClick
        target: area.proxy.tap
        function onSingleTapped(eventPoint, button) {
            const lp = area.toLocalPoint(eventPoint.scenePosition);
            if (!area.contains(lp))
                return;
            switch (button) {
            case Qt.LeftButton:
                area.leftClicked(eventPoint.scenePosition);
                break;
            case Qt.RightButton:
                area.rightClicked(eventPoint.scenePosition);
                break;
            case Qt.MiddleButton:
                area.middleClicked(eventPoint.scenePosition);
            }
        }
        function onDoubleTapped(eventPoint, button) {
            const lp = area.toLocalPoint(eventPoint.scenePosition);
            if (!area.contains(lp))
                return;
            switch (button) {
            case Qt.LeftButton:
                area.doubleClicked(eventPoint.scenePosition);
            }
        }
    }
    Connections {
        enabled: area.active && !area.useDoubleClick
        target: area.proxy.tap
        function onTapped(eventPoint, button) {
            doubleClickConnections.onSingleTapped(eventPoint, button);
        }
    }
}
