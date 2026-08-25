import Quickshell
import qs.modules
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: barLeft
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                bottom: true
            }

            color: Config.colors.bgDark
            implicitWidth: 30
            ColumnLayout {
                anchors.fill: parent
                spacing: 10
                Workspaces {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.topMargin: 6
                }
                Item {
                    Layout.fillHeight: true
                }
                Tray {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                }
                Volume {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Layout.bottomMargin: 6
                }
            }
        }
    }
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

            color: Config.colors.bgDark
            implicitHeight: 25
            Text {
                id: clockText
                text: Time.fullDisplay
                color: Config.colors.text
                anchors.centerIn: parent
            }
            RowLayout {
                anchors.fill: parent
                spacing: 5
                Item {
                    Layout.fillWidth: true
                }
                Search {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
                NotificationCenter {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    Layout.rightMargin: 5
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
