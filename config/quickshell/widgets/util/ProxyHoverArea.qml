import QtQuick
import qs.widgets.util

Item {
    id: area

    required property PointerProxy proxy
    property bool active: true

    signal clicked

    readonly property point localPointer: active ? mapFromItem(null, area.proxy.scenePosition.x, area.proxy.scenePosition.y) : null
    readonly property bool hovered: active && area.proxy.hovered && contains(area.localPointer)

    Connections {
        target: area.proxy
        function onTapped(scenePos) {
            if (!area.active)
                return;
            const lp = area.mapFromItem(null, scenePos.x, scenePos.y);
            if (area.contains(lp))
                area.clicked();
        }
    }
}
