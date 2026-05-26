import Quickshell
import QtQuick
import qs.config
import qs.modules
import qs.modules.bar

ShellRoot {
    Variants {
        model: Quickshell.screens

        BinaryClock {
            required property var modelData

            screen: modelData

            anchors {
                bottom: true
                right: true
            }

            particleColor: Theme.palette.surface
        }
    }

    Variants {
        model: Quickshell.screens

        StatusBar {
            required property var modelData

            screen: modelData
        }
    }
}
