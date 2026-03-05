// ConfirmPrompt.qml
import QtQuick
import Quickshell
import "../core"
import "../../assets"
PanelWindow {
    id: promptWindow
    required property string promptMode
    color: Qt.alpha(Theme.overlay0, 0.2)
    anchors { top: true; bottom: true; left: true; right: true }
    visible: promptRect.visible

    signal dismissed()

    MouseArea {
        anchors.fill: parent
        onClicked: promptRect.visible = false
    }

    Rectangle {
        id: promptRect
        visible: false
        anchors.centerIn: parent
        width: 300; height: 200
        color: Theme.crust
        radius: Config.data.bar.radius
        border { color: Theme.accent; width: 1 }

        MouseArea { anchors.fill: parent; onClicked: {} }

        Text {
            text: "Are you sure?"
            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 50 }
            font.pixelSize: 24
            color: Theme.text
        }

        Rectangle {
            width: 135; height: 25
            anchors { bottom: parent.bottom; bottomMargin: 10; left: parent.left; leftMargin: 10 }
            color: Theme.base
            radius: Config.data.bar.radius
            border { color: Theme.accent; width: 1 }
            Text { text: "Yes"; color: Theme.text; anchors.centerIn: parent }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    promptRect.visible = false
                    if (promptMode === "poweroff")     SystemService.powerOff()
                        else if (promptMode === "restart")  SystemService.restart()
                            else if (promptMode === "lock")     SystemService.lock()
                                else if (promptMode === "sleep")    SystemService.suspend()
                                    else if (promptMode === "logout")   SystemService.logout()
                }
            }
        }

        Rectangle {
            width: 135; height: 25
            anchors { bottom: parent.bottom; bottomMargin: 10; right: parent.right; rightMargin: 10 }
            color: Theme.base
            radius: Config.data.bar.radius
            border { color: Theme.accent; width: 1 }
            Text { text: "No"; color: Theme.text; anchors.centerIn: parent }
            MouseArea { anchors.fill: parent; onClicked: promptRect.visible = false }
        }
    }

    function show() { promptRect.visible = true }
    function hide() { promptRect.visible = false }
}
