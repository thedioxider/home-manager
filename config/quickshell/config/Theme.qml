pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property var palette: ({
            background: "#121c25",
            backgroundAlt: "#0c2e48",
            onBackground: "#98d1ce",
            surface: "#26a98b"
        })
    readonly property var fonts: ({
            symbols: "Symbols Nerd Font Mono",
            text: "CaskaydiaCove NFM"
        })
}
