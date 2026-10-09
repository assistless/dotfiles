pragma Singleton
import QtQuick

QtObject {
    readonly property QtObject colors: QtObject {
        property color bgDark: "#0d0d0d"
        property color bg: "#1a1a1a"
        property color bgLight: "#262626"
        property color accent: "#6633cc"
        property color accentLight: "#7547d1"
        property color accentDark: "#5c2eb8"
        property color red: "#d65c5c"
        property color yellow: "#d6d65c"
        property color green: "#5cd65c"
        property color text: "#ffffff"
        property color textMuted: "#999999"
        property color border: "#4d4d4d"
    }
    readonly property QtObject bar: QtObject {
        property string verticalPosition: "top"
        property string horizontalPosition: "right"
        property int verticalSize: 30
        property int horizontalSize: 35
    }
}
