import Quickshell
import QtQuick
import qs.modules
import qs.services
import "../config.js" as Config

Rectangle {
    id: root
    color: Config.colors.bg
    implicitHeight: 20
    implicitWidth: 25
    Text {
        text: " " + NotificationCount.count
        color: Config.colors.text
        anchors.centerIn: parent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["qs", "ipc", "call", "notifications", "toggle"])
    }
}
