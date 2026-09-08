import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import "../config.js" as Config

Rectangle {
    id: root
    color: Qt.alpha(Config.colors.bg, 0.5)
    implicitHeight: 20
    implicitWidth: 20
    border {
        color: Config.colors.border
        width: 1
    }

    function toggle(): void {
        menu.visible = !menu.visible;
    }
    MouseArea {
        anchors.fill: parent
        onClicked: toggle()
    }
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2
        Text {
            text: "󰐥"
            color: Config.colors.text
            font.pixelSize: 17
            topPadding: -2
            rightPadding: -2
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
        color: Qt.alpha(Config.colors.bgDark, 0.5)
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
