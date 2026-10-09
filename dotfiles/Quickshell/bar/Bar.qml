import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.services

// import qs.modules

Scope {
    PanelWindow {
        id: vertical
        anchors {
            top: Config.bar.verticalPosition == "top" ? true : false
            left: true
            right: true
            bottom: Config.bar.verticalPosition == "bottom" ? true : false
        }
        implicitHeight: Config.bar.verticalSize
        Rectangle {
            id: verticalContent
            anchors.fill: parent
            color: Config.colors.bg
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Windows {
                    Layout.alignment: Qt.AlignLeft
                }
                Item {
                    Layout.fillWidth: true
                }
                SearchButton {}
            }
        }
        RowLayout {
            anchors.centerIn: parent
            Clock {}
        }
    }
    PanelWindow {
        id: horizontal
        anchors {
            top: true
            left: Config.bar.horizontalPosition == "left" ? true : false
            right: Config.bar.horizontalPosition == "right" ? true : false
            bottom: true
        }
        implicitWidth: Config.bar.horizontalSize
        Rectangle {
            id: horizontalContent
            anchors.fill: parent
            color: Config.colors.bg
            ColumnLayout {
                anchors.fill: parent
                anchors.bottomMargin: 10
                Workspaces {
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                }
                Item {
                    Layout.fillHeight: true
                }
                Tray {
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                }
            }
        }
    }
}
