import QtQuick
import Quickshell
import Niri
import Quickshell.Widgets
import Quickshell.Wayland
import "../../assets"
Row {
    spacing: 2
    Text {
        width: 900
        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        text: niri.focusedWindow?.title ?? ""
        font.pixelSize: 16
        color: Theme.text
        visible: true
    }
}
