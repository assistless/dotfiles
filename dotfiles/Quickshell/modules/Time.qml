// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string fullDisplay: {
        Qt.formatDateTime(clock.date, "ddd MMM d, yyyy hh:mm:ss AP")
    }
    readonly property string timeDisplay: {
        Qt.formatDateTime(clock.date, "hh:mm:ss AP")
    }
    readonly property string dateDisplay: {
        Qt.formatDateTime(clock.date, "ddd MMM d, yyyy")
    }
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
