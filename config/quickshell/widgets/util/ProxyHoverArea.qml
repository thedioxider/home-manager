import QtQuick

Item {
    id: area

    required property PointerProxy proxy

    signal clicked()

    readonly property point localPointer: mapFromItem(null, area.proxy.scenePosition.x, area.proxy.scenePosition.y)
    readonly property bool hovered: area.proxy.hovered && contains(area.localPointer)

    Connections {
        target: area.proxy
        function onTapped(scenePos) {
            const lp = area.mapFromItem(null, scenePos.x, scenePos.y);
            if (area.contains(lp))
                area.clicked();
        }
    }
}
