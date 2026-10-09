import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.services
import "../config.js" as Config

Rectangle {
    id: root
    color: Globals.notificationsVisible ? Config.colors.accentDark : mouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : mouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bg, 1)
    implicitHeight: 19
    implicitWidth: layout.implicitWidth + 9
    radius: 9
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2
        Text {
            text: ""
            color: Config.colors.text
            font.pixelSize: 12
            topPadding: -2
        }
        Text {
            text: Globals.notificationCount
            color: Config.colors.text
            visible: Globals.notificationCount > 0
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: Quickshell.execDetached(["qs", "ipc", "call", "notifications", "toggle"])
    }
}
