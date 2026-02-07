import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../../assets"

Rectangle {
    id: powerRoot
    width: 25
    height: 25
    radius: 15
    border.width: 1
    border.color: Theme.mauve
    color: clickArea.containsPress ? Theme.mauve : Theme.surface1
    Behavior on color {
        ColorAnimation { duration: 150 }
    }
    Text {
        anchors.centerIn: parent
        text: "⏻"
        color: clickArea.containsPress ? Theme.base : Theme.mauve
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    MouseArea {
        id: clickArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Quickshell.execDetached({command: ["wlogout"]})
        }
    }
}
