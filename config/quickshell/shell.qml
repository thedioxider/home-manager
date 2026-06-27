//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import qs.config
import qs.modules
import qs.modules.bar
import qs.state

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

    Variants {
        model: Quickshell.screens

        PowerMenu {
            required property var modelData

            screen: modelData
        }
    }

    IpcHandler {
        target: "power-menu"

        function open(): void {
            var name = Hyprland.focusedMonitor.name;
            for (var i = 0; i < Quickshell.screens.length; i++) {
                if (Quickshell.screens[i].name === name) {
                    PowerMenuState.open(Quickshell.screens[i]);
                    return;
                }
            }
            PowerMenuState.open(Quickshell.screens[0]);
        }
    }
}
