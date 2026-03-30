// Launcher.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import "../core"
import "../menu"

PanelWindow {
    id: root
    anchors { top: true; bottom: true; left: true; right: true }
    exclusiveZone: 0
    color: Qt.alpha(Theme.overlay0, 0.0)
    visible: false
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Keys.onEscapePressed: root.hide()

    MouseArea {
        anchors.fill: parent
        onClicked: root.hide()
    }

    Rectangle {
        id: mainPanel
        implicitWidth: 600
        implicitHeight: 420
        anchors.centerIn: parent
        radius: Config.data.bar.radius
        color: Theme.mantle
        border { color: Theme.accent; width: 3 }

        transform: Scale { id: panelScale; origin.x: mainPanel.width / 2; origin.y: mainPanel.height / 2; xScale: 0.92; yScale: 0.92 }
        opacity: 0

        NumberAnimation on opacity { id: fadeIn;  from: 0; to: 1; duration: 150; easing.type: Easing.OutCubic; running: false }
        NumberAnimation on opacity { id: fadeOut; from: 1; to: 0; duration: 120; easing.type: Easing.InCubic;  running: false
            onStopped: root.visible = false
        }
        NumberAnimation { id: scaleIn;   target: panelScale; property: "xScale"; from: 0.92; to: 1;    duration: 150; easing.type: Easing.OutCubic; running: false }
        NumberAnimation { id: scaleIn2;  target: panelScale; property: "yScale"; from: 0.92; to: 1;    duration: 150; easing.type: Easing.OutCubic; running: false }
        NumberAnimation { id: scaleOut;  target: panelScale; property: "xScale"; from: 1;    to: 0.92; duration: 120; easing.type: Easing.InCubic;  running: false }
        NumberAnimation { id: scaleOut2; target: panelScale; property: "yScale"; from: 1;    to: 0.92; duration: 120; easing.type: Easing.InCubic;  running: false }

        MouseArea { anchors.fill: parent; onClicked: {} }

        Apps {
            id: apps
            showMostUsed: false
            anchors.fill: parent
            anchors.margins: 8
            onCloseRequested: root.hide()
        }
    }

    function show() {
        root.visible = true
        fadeOut.running = false; scaleOut.running = false; scaleOut2.running = false
        fadeIn.running = true;   scaleIn.running = true;   scaleIn2.running = true
        apps.focusSearch()
    }

    function hide() {
        fadeIn.running = false; scaleIn.running = false; scaleIn2.running = false
        fadeOut.running = true; scaleOut.running = true;  scaleOut2.running = true
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            if (root.visible) root.hide()
                else root.show()
        }
    }
}
