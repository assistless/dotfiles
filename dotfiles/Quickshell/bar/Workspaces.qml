import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

RowLayout {
    Repeater {
        model: 10
        Rectangle {
            width: 15
            height: 15
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            color: isActive ? Config.colors.accent : (ws ? Config.colors.bgLight : Config.colors.bg)
            Text {
                text: index + 1
                anchors.centerIn: parent
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${(index + 1)} })`)
            }
        }
    }
}
