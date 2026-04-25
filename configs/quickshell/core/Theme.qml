pragma Singleton
import QtQuick


QtObject {
    id: theme

    // Links to your config.json via the Config singleton
    readonly property bool isDark: Config.isDarkTheme
    readonly property int duration: 400
    readonly property string accentName: Config.data.theme.accent ?? "mauve"
    readonly property color accent: theme[accentName] ?? theme.mauve

    // --- Warm Tones ---
    readonly property color rosewater: isDark ? "#f06292" : "#d81b60"
    readonly property color flamingo:  isDark ? "#ec407a" : "#e91e63"
    readonly property color pink:      isDark ? "#f48fb1" : "#d81b60"
    readonly property color mauve:     isDark ? "#ba68c8" : "#8e24aa"
    readonly property color red:       isDark ? "#ef5350" : "#e53935"
    readonly property color maroon:    isDark ? "#e53935" : "#c62828"
    readonly property color peach:     isDark ? "#ffa726" : "#fb8c00"
    readonly property color yellow:    isDark ? "#ffee58" : "#fdd835"

    // --- Cool Tones ---
    readonly property color green:     isDark ? "#66bb6a" : "#43a047"
    readonly property color teal:      isDark ? "#26c6da" : "#00897b"
    readonly property color sky:       isDark ? "#29b6f6" : "#039be5"
    readonly property color sapphire:  isDark ? "#26c6da" : "#00acc1"
    readonly property color blue:      isDark ? "#42a5f5" : "#1e88e5"
    readonly property color lavender:  isDark ? "#7986cb" : "#5c6bc0"

    // --- Text & Overlays ---
    readonly property color text:      isDark ? "#ececec" : "#212121"
    readonly property color subtext1:  isDark ? "#d0d0d0" : "#424242"
    readonly property color subtext0:  isDark ? "#b0b0b0" : "#616161"
    readonly property color overlay2:  isDark ? "#8a8a8a" : "#757575"
    readonly property color overlay1:  isDark ? "#6e6e6e" : "#9e9e9e"
    readonly property color overlay0:  isDark ? "#545454" : "#bdbdbd"

    // --- Backgrounds & Surfaces ---
    readonly property color surface2:  isDark ? "#484848" : "#e0e0e0"
    readonly property color surface1:  isDark ? "#383838" : "#eeeeee"
    readonly property color surface0:  isDark ? "#2c2c2c" : "#f5f5f5"
    readonly property color base:      isDark ? "#1e1e1e" : "#ffffff"
    readonly property color mantle:    isDark ? "#181818" : "#fafafa"
    readonly property color crust:     isDark ? "#121212" : "#f0f0f0"
}
