import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import Niri
import "../../assets"
Rectangle {
    border.width: 1
    border.color: Theme.mauve
    id: root
    property bool workspaceVisible: false
    function toggleWorkspace(): void {
        workspaceVisible = !workspaceVisible
    }
    anchors.left: parent.left
    height: 25
    width: 25
    radius: 15
    color: workspaceVisible ? Theme.mauve : Theme.surface1
    Behavior on color {
        ColorAnimation { duration: 100 }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: root.toggleWorkspace()
    }
    Text {
        anchors.centerIn: parent
        text: ""
        font.pixelSize: 20
        color: workspaceVisible ? Theme.base : Theme.mauve
    }
    LazyLoader {
        active: root.workspaceVisible

        PanelWindow {
            anchors {
                bottom: true
                left: true
            }
            margins {
                bottom: 5
                left: 5
            }
            implicitWidth: 35
            implicitHeight: 220
            color: "#00000000"
            Rectangle {
                anchors.centerIn: parent
                implicitWidth: 35
                implicitHeight: 220
                radius: 20
                color: Theme.crust
                border.width: 2
                border.color: Theme.mauve
                Rectangle {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    radius: 15
                    implicitWidth: 25
                    implicitHeight: 210
                    color: Theme.surface0
                    Column {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                        spacing: 5
                        Repeater {
                            model: niri.workspaces

                            Rectangle {
                                visible: index < 11
                                width: 15
                                height: 15
                                radius: 15
                                color: model.isActive ? Theme.mauve : Theme.overlay0
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        niri.focusWorkspaceById(model.id)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    LazyLoader {
        active: root.workspaceVisible

        PanelWindow {
            anchors {
                bottom: true
                top: true
                left: true
                right: true
            }
            color: Qt.hsla(0,0,0,0.3)
            exclusiveZone: 0
            MouseArea {
                anchors.fill: parent
                onClicked: root.toggleWorkspace()
            }
        }
    }
}
