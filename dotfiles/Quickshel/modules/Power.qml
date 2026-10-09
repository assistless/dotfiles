import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import qs.modules
import "../config.js" as Config

Rectangle {
    id: root
    color: mouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : menu.visible ? Config.colors.accentDark : mouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bg, 1)
    implicitHeight: 19
    implicitWidth: 19
    radius: 10

    function toggle(): void {
        menu.visible = !menu.visible;
    }
    MouseArea {
        id: mouse
        hoverEnabled: true
        anchors.fill: parent
        onClicked: toggle()
    }
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2
        Text {
            text: ""
            color: Config.colors.text
            font.pixelSize: 12
            topPadding: -2
            leftPadding: 1.5
        }
    }
    PanelWindow {
        id: menu
        anchors {
            left: true
            right: true
            top: true
        }
        visible: false
        exclusiveZone: 0
        color: Qt.alpha(Config.colors.bg, 1)
        BackgroundEffect.blurRegion: Region {
            item: menu.contentItem
        }
        implicitHeight: 50

        RowLayout {
            anchors.centerIn: parent
            Rectangle {
                id: powerButton
                color: Qt.alpha(Config.colors.bg, 0.5)
                implicitHeight: 35
                implicitWidth: powerButtonRow.implicitWidth + 20
                border {
                    color: Config.colors.border
                    width: 1
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["poweroff"])
                }
                RowLayout {
                    id: powerButtonRow
                    anchors.centerIn: parent
                    Text {
                        text: "󰐥"
                        color: Config.colors.text
                        Layout.alignment: Qt.AlignCenter
                        font.pixelSize: 24
                        topPadding: -3
                    }
                    Text {
                        text: "Power off"
                        color: Config.colors.text
                    }
                }
            }
            Rectangle {
                id: restartButton
                color: Qt.alpha(Config.colors.bg, 0.5)
                implicitHeight: 35
                implicitWidth: restartButtonRow.implicitWidth + 20
                border {
                    color: Config.colors.border
                    width: 1
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["reboot"])
                }
                RowLayout {
                    id: restartButtonRow
                    anchors.centerIn: parent
                    Text {
                        text: "󰜉"
                        color: Config.colors.text
                        Layout.alignment: Qt.AlignCenter
                        font.pixelSize: 24
                        topPadding: -5
                    }
                    Text {
                        text: "Restart"
                        color: Config.colors.text
                    }
                }
            }
            Rectangle {
                id: lockButton
                color: Qt.alpha(Config.colors.bg, 0.5)
                implicitHeight: 35
                implicitWidth: lockButtonRow.implicitWidth + 20
                border {
                    color: Config.colors.border
                    width: 1
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["qs", "ipc", "call", "lock", "lock"])
                }
                RowLayout {
                    id: lockButtonRow
                    anchors.centerIn: parent
                    Text {
                        text: "󰌾"
                        color: Config.colors.text
                        Layout.alignment: Qt.AlignCenter
                        font.pixelSize: 24
                        topPadding: -5
                    }
                    Text {
                        text: "Lock"
                        color: Config.colors.text
                    }
                }
            }
        }
        Rectangle {
            color: Qt.alpha(Config.colors.bg, 0.5)
            implicitHeight: 20
            implicitWidth: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            border {
                color: Config.colors.border
                width: 1
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.toggle()
            }
            RowLayout {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    text: "󰅖"
                    color: Config.colors.text
                    font.pixelSize: 17
                    topPadding: -2
                    rightPadding: -1
                }
            }
        }
    }
}
