import Quickshell
import QtQuick

Variants {
    model: Quickshell.screens

    BinaryClock {
        required property var modelData

        screen: modelData

        anchors {
            bottom: true
            right: true
        }

        particleColor: "#42f566"
    }
}
