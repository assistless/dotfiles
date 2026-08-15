import Quickshell
import Quickshell.Wayland
import QtQuick

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
}
