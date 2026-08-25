import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.services
import "../config.js" as Config

Rectangle {
    id: root
    color: Config.colors.bg
    implicitHeight: 20
    implicitWidth: 20
    border {
        color: Config.colors.border
        width: 1
    }
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2
        Text {
            text: "  "
            color: Config.colors.text
            font.pixelSize: 12
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["qs", "ipc", "call", "launcher", "toggle"])
    }
}