import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "../../assets"
Rectangle {
    Text {
        id: powerDisplay
        anchors {
            verticalCenter: parent.verticalCenter
        }
        text: {
            var state = UPower.displayDevice.state

            // Check for Charging (3), FullyCharged (4), or PendingCharge (1)
            // The UPowerDeviceState enum values are:
            // 0: Unknown, 1: PendingDischarge, 2: Discharging, 3: Charging, 4: FullyCharged, 5: Empty, 6: PendingCharge

            if (state === UPowerDeviceState.Charging ||
                state === UPowerDeviceState.FullyCharged ||
                state === UPowerDeviceState.PendingCharge)
            {
                return "ok"
            } else {
                return "no"
            }
        }
        color: Theme.text
        font.pixelSize: 16
        Component.onCompleted: {
            parent.width = powerDisplay.contentWidth
        }
    }
}
