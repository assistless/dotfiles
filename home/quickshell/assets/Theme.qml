pragma Singleton
import QtQuick
import "../modules/core/"

QtObject {
    id: theme

    // Links to your config.json via the Config singleton
    readonly property bool isDark: Config.data.theme.dark
    readonly property int duration: 400

    // --- Warm Tones ---
    readonly property color rosewater: isDark ? "#f5e0dc" : "#dc8a78"
    readonly property color flamingo:  isDark ? "#f2cdcd" : "#dd7878"
    readonly property color pink:      isDark ? "#f5c2e7" : "#ea76cb"
    readonly property color mauve:     isDark ? "#cba6f7" : "#8839ef"
    readonly property color red:       isDark ? "#f38ba8" : "#d20f39"
    readonly property color maroon:    isDark ? "#eba0ac" : "#e64553"
    readonly property color peach:     isDark ? "#fab387" : "#fe640b"
    readonly property color yellow:    isDark ? "#f9e2af" : "#df8e1d"

    // --- Cool Tones ---
    readonly property color green:     isDark ? "#a6e3a1" : "#40a02b"
    readonly property color teal:      isDark ? "#94e2d5" : "#179299"
    readonly property color sky:       isDark ? "#89dceb" : "#04a5e5"
    readonly property color sapphire:  isDark ? "#74c7ec" : "#209fb5"
    readonly property color blue:      isDark ? "#89b4fa" : "#1e66f5"
    readonly property color lavender:  isDark ? "#b4befe" : "#7287fd"

    // --- Text & Overlays ---
    readonly property color text:      isDark ? "#cdd6f4" : "#4c4f69"
    readonly property color subtext1:  isDark ? "#bac2de" : "#5c5f77"
    readonly property color subtext0:  isDark ? "#a6adc8" : "#6c6f85"
    readonly property color overlay2:  isDark ? "#9399b2" : "#7c7f93"
    readonly property color overlay1:  isDark ? "#7f849c" : "#8c8fa1"
    readonly property color overlay0:  isDark ? "#6c7086" : "#9ca0b0"

    // --- Backgrounds & Surfaces ---
    readonly property color surface2:  isDark ? "#585b70" : "#acb0be"
    readonly property color surface1:  isDark ? "#45475a" : "#bcc0cc"
    readonly property color surface0:  isDark ? "#313244" : "#ccd0da"
    readonly property color base:      isDark ? "#1e1e2e" : "#eff1f5"
    readonly property color mantle:    isDark ? "#181825" : "#e6e9ef"
    readonly property color crust:     isDark ? "#11111b" : "#dce0e8"
}
