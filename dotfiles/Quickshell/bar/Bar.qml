import Quickshell
import qs.modules
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

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

            color: "transparent"
            implicitHeight: 32

            RowLayout {
                anchors.fill: parent
                anchors.topMargin: 3
                anchors.bottomMargin: 3
                anchors.leftMargin: 3
                anchors.rightMargin: 3
                spacing: 8

                Compartment {
                    Workspaces {
                        id: workspaces
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Compartment {
                    Tray {
                        id: tray
                    }
                }

                Compartment {
                    Volume {}
                }
            }

            RowLayout {
                anchors.centerIn: parent
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 3
                anchors.bottomMargin: 3
                spacing: 8

                Compartment {
                    Text {
                        id: clockText
                        text: Time.fullDisplay
                        color: Config.colors.text
                        font.pixelSize: 13
                    }
                }

                Compartment {
                    horizontalPadding: 4
                    NotificationCenter {
                        id: notifications
                    }
                }
            }
        }
    }

    component Compartment: Rectangle {
        id: compartment

        default property alias content: container.children

        property real horizontalPadding: 8
        property real verticalPadding: 4
        property real contentSpacing: 6

        color: Config.colors.bgDark
        border.color: Config.colors.border
        border.width: 1

        Layout.fillHeight: true

        implicitWidth: container.implicitWidth + (horizontalPadding * 2)
        implicitHeight: container.implicitHeight + (verticalPadding * 2)

        RowLayout {
            id: container
            anchors.centerIn: parent
            spacing: compartment.contentSpacing
        }
    }
}
