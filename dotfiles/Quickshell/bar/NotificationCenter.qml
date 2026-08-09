import Quickshell
import QtQuick

Rectangle {
  id: root
  color: "black"
  implicitHeight: 20
  implicitWidth: 20
  Text {
    text: "N"
    color: "white"
    anchors.centerIn: parent
  }
  MouseArea {
    anchors.fill: parent
    onClicked: Quickshell.execDetached(["qs", "ipc", "call", "notifications", "toggle"])
  }
}
