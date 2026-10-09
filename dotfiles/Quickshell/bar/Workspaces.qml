import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs

Rectangle {
    implicitHeight: workspaces.implicitHeight + 10
    implicitWidth: 25
    radius: 20
    color: Config.colors.bgLight
    ColumnLayout {
      id: workspaces
      anchors.centerIn: parent
        Repeater {
            model: 10
            Rectangle {
                width: 20
                height: 20
                radius: 10
                color: mouse.containsPress ? Config.colors.accent : Config.colors.bg
                property var hasWindow: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                border {
                    width: 2
                    color: mouse.containsMouse ? Config.colors.accent : "transparent"
                }
                Text {
                    anchors.centerIn: parent
                    color: mouse.containsPress ? Config.colors.text : isActive ? Config.colors.accent : hasWindow ? Config.colors.text : Config.colors.textMuted
                    text: model.index + 1
                    font.pixelSize: 10
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
}
