import Quickshell
import qs.modules
import QtQuick
import QtQuick.Layouts
Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 26
            RowLayout {
                anchors.fill: parent
                Workspaces {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 5
                }
                Item {
                    Layout.fillWidth: true
                }
                Tray {}
                NotificationCenter {}
                Volume {}
                Text {
                    text: Time.fullDisplay
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.rightMargin: 5
                }
            }
            Text {
                text: "john placeholder"
                anchors.centerIn: parent
            }
        }
    }
}
