import QtQuick
import QtQuick.Layouts
import Quickshell
import Niri
import Quickshell.Widgets
import Quickshell.Wayland
import "../../assets"
import "../core"
Row {
    spacing: 5
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 22
        height: 22
        color: "#00000000"
        Image {
            id: icon
            source: "file://" + niri.focusedWindow?.iconPath
            sourceSize.width: 20
            sourceSize.height: 20
            visible: niri.focusedWindow.iconPath !== ""
            smooth: true
            anchors.centerIn: parent
        }
        Image {
            id: iconEmpty
            source: "file:///home/demi/.config/quickshell/assets/Debugempty.png"
            sourceSize.width: 20
            sourceSize.height: 20
            visible: niri.focusedWindow.iconPath == ""
            smooth: true
        }
    }
    Text {
        id: title
        width: 900
        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        text: niri.focusedWindow?.title ?? ""
        font.pixelSize: 16
        color: Theme.text
        visible: true
        }
}
