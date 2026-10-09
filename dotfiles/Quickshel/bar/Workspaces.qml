import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

ColumnLayout {
    Repeater {
        model: 10
        Rectangle {
            width: 18
            height: 18
            radius: 10
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            color: mouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : mouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : isActive ? Qt.alpha(Config.colors.accent, 1) : (ws ? Qt.alpha(Config.colors.bg, 1) : Qt.alpha(Config.colors.bg, 1))
            Text {
                text: index + 1
                anchors.centerIn: parent
                font.pixelSize: 10
                color: isActive ? Config.colors.text : (ws ? mouse.containsMouse ? Qt.alpha(Config.colors.text, 1) : Qt.alpha(Config.colors.accent, 1) : Config.colors.textMuted)
            }
            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${(index + 1)} })`)
            }
        }
    }
}
