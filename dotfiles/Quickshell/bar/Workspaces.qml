import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
RowLayout {
    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            width: 15
            height: 15
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            color: isActive ? "#ff0000" : (ws ? "#bb0000" : "#000000")
            Text {
                text: index + 1
                anchors.centerIn: parent
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${(index + 1)} })`);
            }
        }
    }
}
