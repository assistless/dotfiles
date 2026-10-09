import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.services
import "../config.js" as Config

Rectangle {
    id: root
    color: Globals.launcherVisible ? Config.colors.accentDark : mouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : mouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bg, 1)
    implicitHeight: 19
    implicitWidth: 19
    radius: 10
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2
        Text {
            text: ""
            color: Config.colors.text
            font.pixelSize: 12
            topPadding: -1
            leftPadding: 1
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: Quickshell.execDetached(["qs", "ipc", "call", "launcher", "toggle"])
    }
}