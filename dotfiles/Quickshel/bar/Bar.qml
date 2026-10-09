import Quickshell
import Quickshell.Wayland
import qs.modules
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: barTop
            required property var modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }
            RowLayout {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                Mpris {}
            }
            color: Config.colors.bg
            implicitHeight: 26
            Compartment {
                anchors.centerIn: parent
                horizontalPadding: 8
                verticalPadding: 2
                Text {
                    id: clockText
                    text: Time.fullDisplay
                    color: Config.colors.text
                    anchors.centerIn: parent
                }
            }

            RowLayout {
                id: right
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                spacing: 5
                Search {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
                NotificationCenter {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
                Power {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
            }
        }
    }
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: barRight
            required property var modelData
            screen: modelData

            anchors {
                top: true
                right: true
                bottom: true
            }
            color: Config.colors.bg
            implicitWidth: 30
            ColumnLayout {
                anchors.fill: parent
                spacing: 8
                Compartment {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.topMargin: 2
                    horizontalPadding: 3
                    verticalPadding: 3
                    
                    Workspaces {
                        id: workspaces
                        anchors.centerIn: parent
                    }
                }
                Item {
                    Layout.fillHeight: true
                }
                Compartment {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    horizontalPadding: 4
                    verticalPadding: 4
                    Tray {}
                }
                Volume {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Layout.bottomMargin: 5
                }
            }
        }
    }
    component Compartment: Rectangle {
        id: compartment

        default property alias content: container.children
        radius: 9
        property real horizontalPadding: 0
        property real verticalPadding: 0
        property real contentSpacing: 6
        color: Config.colors.bgLight

        implicitWidth: container.implicitWidth + (horizontalPadding * 2)
        implicitHeight: container.implicitHeight + (verticalPadding * 2)

        RowLayout {
            id: container
            anchors.centerIn: parent
            spacing: compartment.contentSpacing
        }
    }
}
