pragma Singleton

import Quickshell

Singleton {
    property var activeScreen: null

    function open(screen) { activeScreen = screen }
    function close() { activeScreen = null }
}
