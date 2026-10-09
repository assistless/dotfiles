import QtQuick
import Quickshell 
import Quickshell.Wayland
import qs.bar
import qs.modules

ShellRoot {
  Variants {
    model: Quickshell.screens
    PanelWindow {
      exclusionMode: ExclusionMode.Ignore
      anchors {
        left: true
        right: true
        top: true
        bottom: true
      }
      WlrLayershell.layer: WlrLayer.Bottom
      color: Config.colors.bgDark
    }
  }
  Bar {}
  Notification {}
}