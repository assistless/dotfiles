// WorkspaceBar.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Niri
import "../core"


Rectangle {
    id: workspacesPanel
    required property real panelY
    required property real panelOpacity

    implicitWidth: 215
    implicitHeight: 35
    radius: Config.data.bar.radius
    color: Theme.mantle

    transform: Translate { y: panelY }
    opacity: panelOpacity

    MouseArea { anchors.fill: parent; onClicked: {} }

    Rectangle {
        anchors.centerIn: parent
        border { width: 1; color: Theme.accent }
        radius: Config.data.bar.radius
        implicitWidth: 205
        implicitHeight: 25
        color: Theme.crust

        Row {
            anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 5 }
            spacing: 5
            Repeater {
                model: niri.workspaces
                Component.onCompleted: { niri.workspaces.maxCount = 10 }
                Rectangle {
                    visible: index < 11
                    width: 15; height: 15
                    radius: Config.data.bar.radius
                    color: model.isActive ? Theme.accent : Theme.surface2
                    MouseArea {
                        anchors.fill: parent
                        onClicked: niri.focusWorkspaceById(model.id)
                    }
                }
            }
        }
    }
}
