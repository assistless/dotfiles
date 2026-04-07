import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "../core"
Rectangle {
    property int run: 0
    property int battery: Number(UPower.displayDevice.percentage * 100)
    width: powerDisplay.contentWidth
    Text {
        id: powerDisplay
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        text: battery + "%"
        color: Theme.text
        font.pixelSize: 16
        Component.onCompleted: {
            if (run > 0) {
                parent.width = powerDisplay.contentWidth
            }
            run = 1
        }
    }
}
