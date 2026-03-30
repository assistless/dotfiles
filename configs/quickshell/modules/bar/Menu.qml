// Menu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Niri

import "../core"
import "../menu"

Rectangle {
    id: root
    border { width: 1; color: Theme.accent }
    property bool workspaceVisible: false
    property bool closing: false

    function toggleWorkspace(): void {
        if (workspaceVisible && !closing) { closing = true }
        else if (!workspaceVisible) { closing = false; workspaceVisible = true }
    }

    anchors.left: parent.left
    height: 25; width: 25
    radius: Config.data.bar.radius
    color: workspaceVisible ? Theme.accent : Theme.surface0
    Behavior on color { ColorAnimation { duration: 100 } }

    IpcHandler {
        target: "menu"
        function toggle() {
            root.toggleWorkspace()
        }
    }

    MouseArea {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: -4    // adjust these to taste
            bottomMargin: -4
            leftMargin: -100
        }
        onClicked: root.toggleWorkspace()
    }

    Text {
        anchors.centerIn: parent
        text: ""; font.pixelSize: 18
        color: workspaceVisible ? Theme.base : Theme.accent
    }

    LazyLoader {
        active: root.workspaceVisible || root.closing

        PanelWindow {
            id: menu
            property string promptMode: ""
            anchors { bottom: true; left: true; top: true; right: true }
            exclusiveZone: 0
            color: Qt.alpha(Theme.overlay0, 0.0)
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            Keys.onEscapePressed: root.toggleWorkspace()

            MouseArea { anchors.fill: parent; onClicked: root.toggleWorkspace() }

            Rectangle {
                id: mainPanel
                implicitHeight: 500; implicitWidth: 600
                radius: Config.data.bar.radius
                color: Theme.mantle
                border { color: Theme.accent; width: 3 }
                anchors { left: parent.left; bottom: parent.bottom; leftMargin: 5; bottomMargin: 5 }

                transform: Translate { id: mainPanelTranslate; y: 500 }
                opacity: 0

                Component.onCompleted: {
                    mainPanelFade.running = true
                    slideUp.running = true
                    apps.focusSearch()
                }

                Connections {
                    target: root
                    function onClosingChanged() {
                        if (root.closing) {
                            slideUp.running = false; mainPanelFade.running = false
                            slideDown.running = true; slideDownFade.running = true
                        }
                    }
                }

                NumberAnimation { id: slideUp; target: mainPanelTranslate; property: "y"; from: 500; to: 0; duration: 300; easing.type: Easing.OutCubic }
                NumberAnimation on opacity { id: mainPanelFade; from: 0; to: 1; duration: 250; easing.type: Easing.OutCubic; running: false }
                NumberAnimation { id: slideDown; target: mainPanelTranslate; property: "y"; from: 0; to: 500; duration: 300; easing.type: Easing.InCubic; running: false
                    onStopped: { root.workspaceVisible = false; root.closing = false }
                }
                NumberAnimation on opacity { id: slideDownFade; from: 1; to: 0; duration: 250; easing.type: Easing.InCubic; running: false }

                MouseArea { anchors.fill: parent; onClicked: {} }

                Workspaces {
                    anchors { left: parent.left; bottom: parent.bottom; leftMargin: 3; bottomMargin: 3 }
                    panelY: mainPanelTranslate.y
                    panelOpacity: mainPanel.opacity
                }

                Power {
                    anchors { right: parent.right; bottom: parent.bottom; rightMargin: 8; bottomMargin: 8 }
                    onActionRequested: (action) => { menu.promptMode = action; confirmPrompt.show() }
                }

                Apps {
                    id: apps
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        bottomMargin: 48
                    }
                    onCloseRequested: root.toggleWorkspace()
                }

                Prompt {
                    id: confirmPrompt
                    promptMode: menu.promptMode
                }
            }
        }
    }
}
