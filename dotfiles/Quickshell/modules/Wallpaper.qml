import Quickshell
import Quickshell.Wayland
import QtQuick
import "../config.js" as Config

PanelWindow {
    exclusionMode: ExclusionMode.Ignore
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    WlrLayershell.layer: WlrLayer.Bottom
    color: "black"
    Text {
        color: Config.colors.text
        text: "Uh oh!"
        anchors.centerIn: parent
    }
    Image {
        source: "file://" + Quickshell.shellPath("wallpaper.jpg")
        fillMode: Image.PreserveAspectFill
        clip: true
        anchors.fill: parent
    }
}
