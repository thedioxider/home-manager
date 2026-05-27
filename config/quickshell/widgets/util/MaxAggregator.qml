import QtQuick

// Collects per-index values reported by a set of items and exposes their
// maximum. Bounded by `count` so stale entries from removed items are ignored
// without needing to clear on every change.
QtObject {
    property int count: 0
    property var values: ({})

    readonly property real max: {
        let m = 0;
        for (let i = 0; i < count; i++)
            m = Math.max(m, values[i] ?? 0);
        return m;
    }

    function report(index: int, value: real) {
        let o = Object.assign({}, values);
        o[index] = value;
        values = o;
    }
}
