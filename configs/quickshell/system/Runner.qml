import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import "../core"

PanelWindow {
    id: root
    anchors { top: true; left: true; right: true }
    exclusiveZone: 0
    implicitHeight: 25
    color: Qt.alpha(Theme.overlay0, 0.0)
    visible: false
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    MouseArea {
        anchors.fill: parent
        onClicked: root.hide()
    }

    Rectangle {
        id: mainPanel
        anchors.fill: parent
        anchors.centerIn: parent
        color: Theme.surface0

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 6
            spacing: 6

            TextInput {
                id: commandInput
                Layout.fillWidth: true
                color: Theme.text
                font.pixelSize: 16
                font.family: "Hitmarker Text VF"
                verticalAlignment: TextInput.AlignVCenter

                onTextChanged: {
                    if (text != "") {
                        tt.visible = false
                    } else tt.visible = true
                }
                Text {
                    id: tt
                    text: "Run..."
                    font.family: "Hitmarker VF"
                    color: Theme.subtext0
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                    font.italic: true
                }

                Keys.onEscapePressed: root.hide()
                Keys.onReturnPressed: {
                    if (text.trim()) {
                        Quickshell.execDetached({command: text.trim().split(/\s+/)})
                        root.hide()
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {}
            cursorShape: Qt.PointingHandCursor
        }
    }

    function show() {
        root.visible = true
        commandInput.forceActiveFocus()
        commandInput.text = ""
        commandInput.selectAll()
    }

    function hide() {
        root.visible = false
    }

    IpcHandler {
        target: "runner"
        function toggle() {
            if (root.visible) root.hide()
            else root.show()
        }
    }
}
