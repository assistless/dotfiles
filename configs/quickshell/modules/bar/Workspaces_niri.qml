import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import Quickshell.Hyprland
import "../core" as Core
Rectangle {
    anchors.left: parent.left
    color: "#666666"
    height: 25
    width: 215

    Rectangle {
        id: workspaceLayout
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
        }

        RowLayout {
            anchors {
                verticalCenter: parent.verticalCenter
            }
            spacing: 5

            Repeater {
                model: 10

                Rectangle {
                    visible: index < 11
                    width: 15
                    height: 15
                    color: Hyprland.focusedMonitor.activeWorkspace.id === (index + 1) ? "#000000" : "#333333"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Core.Hypr.switchWorkspace(index + 1)
                    }
                }
            }
        }
    }
}
