import QtQuick
import qs
import qs.services
Rectangle {
    implicitHeight: 20
    implicitWidth: 150
    radius: 10
    color: Config.colors.bgLight
    Text {
        anchors.centerIn: parent
        text: Time.fullDisplay
        font.pixelSize: 12
        color: Config.colors.text
    }
}
