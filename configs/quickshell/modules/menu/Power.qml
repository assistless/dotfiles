// PowerButtons.qml
import QtQuick
import QtQuick.Layouts
import "../core"

RowLayout {
    id: powerButtons
    spacing: 5

    signal actionRequested(string action)

    Repeater {
        model: [
            { label: "󰐥 Power off", mode: "poweroff", width: 105 },
            { label: "󰜉 Restart",  mode: "restart",  width: 90  },
            { label: "󰌾",          mode: "lock",     width: 25  },
            { label: "󰤄",         mode: "sleep",    width: 25  },
            { label: "󰗽",         mode: "logout",   width: 25  },
        ]
        Rectangle {
            radius: Config.data.bar.radius
            width: modelData.width; height: 25
            color: Theme.crust
            border { width: 1; color: Theme.accent }
            Text { anchors.centerIn: parent; text: modelData.label; color: Theme.text }
            MouseArea {
                anchors.fill: parent
                onClicked: powerButtons.actionRequested(modelData.mode)
            }
        }
    }
}
