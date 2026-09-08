import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.services
import "../config.js" as Config

Rectangle {
    id: root
    color: Qt.alpha(Config.colors.bg, 0.5)
    implicitHeight: 20
    implicitWidth: layout.implicitWidth + 10
    border {
        color: Config.colors.border
        width: 1
    }
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2
        Text {
            text: "󰂚"
            color: Config.colors.text
            font.pixelSize: 13
        }
        Text {
            text: NotificationCount.count
            color: Config.colors.text
            visible: NotificationCount.count > 0
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["qs", "ipc", "call", "notifications", "toggle"])
    }
}
