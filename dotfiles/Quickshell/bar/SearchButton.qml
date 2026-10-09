import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.services
import qs

Rectangle {
    id: root
    color: mouse.containsPress ? Config.colors.accent : "transparent"
    border {
        width: 2
        color: mouse.containsMouse ? Config.colors.accent : "transparent"
    }
    implicitHeight: 20
    implicitWidth: 20
    radius: 10
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2
        Text {
            text: ""
            color: Config.colors.text
            font.pixelSize: 10
            topPadding: -1
            leftPadding: 1
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {}
    }
}
