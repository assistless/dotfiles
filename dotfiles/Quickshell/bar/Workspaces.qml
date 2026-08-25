import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

ColumnLayout {
    Repeater {
        model: 10
        Rectangle {
            width: 20
            height: 20
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            color: isActive ? Config.colors.accent : (ws ? Config.colors.bgLight : Config.colors.bg)
            border {
                width: 1
                color: isActive ? Config.colors.border : (ws ? Config.colors.accent : Config.colors.border)
            }
            Text {
                text: index + 1
                anchors.centerIn: parent
                color: isActive ? Config.colors.text : (ws ? Config.colors.accent : Config.colors.textMuted)
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${(index + 1)} })`)
            }
        }
    }
}
