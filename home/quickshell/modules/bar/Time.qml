import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import "../../assets"
Rectangle {
    id: root

    width: time.contentWidth
    height: 30
    color: "transparent"
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        id: time
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(clock.date, "hh:mm:ss")
        color: Theme.text
        font.pixelSize: 16
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        ToolTip {
            popupType: Popup.Native
            visible: parent.containsMouse
            delay: 500  // 500ms delay before showing
            contentItem: Text {
                text: Qt.formatDateTime(clock.date, "ddd, MMM d yyyy")
                color: Theme.text
            }
            background: Rectangle {
                color: Theme.crust
                radius: 0
            }
        }
    }
}
