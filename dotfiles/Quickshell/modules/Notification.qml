import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.services

Scope {
    PanelWindow {
        anchors {
            top: true
            right: true
        }
        WlrLayershell.layer: WlrLayer.Overlay
        implicitWidth: 380
        implicitHeight: Math.max(0, column.implicitHeight)

        color: "transparent"

        exclusiveZone: 0
	MouseArea {
	    anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 0

            Repeater {
                model: NotificationService.server.trackedNotifications
                delegate: Rectangle {
                    id: card
                    required property var modelData
                    visible: card.modelData.urgency === NotificationUrgency.Low ? false : true
                    Layout.fillWidth: true
                    Layout.preferredHeight: layout.implicitHeight + 20
                    color: Config.colors.bg
                    clip: true
                    Timer {
                        running: true
                        interval: 5000
                        onTriggered: card.modelData.expire()
                    }

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || (card.modelData.appIcon ? Quickshell.iconPath(card.modelData.appIcon) : "")
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5

                            RowLayout {
                                Text {
                                    Layout.fillWidth: true
                                    text: card.modelData.summary
                                    font.bold: true
                                    wrapMode: Text.WordWrap
                                    color: Config.colors.text
                                }
                                Item {
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: Qt.formatDateTime(new Date(), "HH:mm")
                                    Layout.alignment: Qt.AlignTop
                                    Layout.topMargin: 3
                                    color: Config.colors.textMuted
                                }
                                Rectangle {
                                    Layout.alignment: Qt.AlignTop | Qt.AlignRight
                                    implicitHeight: 20
                                    implicitWidth: 20
                                    radius: 90
                                    color: dismissMouse.containsPress ? Config.colors.accent : Config.colors.bgLight
                                    border {
                                        width: 2
                                        color: dismissMouse.containsMouse ? Config.colors.accent : "transparent"
                                    }
                                    Text {
                                        text: "󰅖"
                                        anchors.centerIn: parent
                                        color: Config.colors.text
                                        anchors.horizontalCenterOffset: 0.5
                                        anchors.verticalCenterOffset: -0.5
                                        font.pixelSize: 16
                                    }
                                    MouseArea {
                                        id: dismissMouse
                                        anchors.fill: parent
                                        onClicked: card.modelData.dismiss()
                                        hoverEnabled: true
                                    }
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                wrapMode: Text.WordWrap
                                color: Config.colors.textMuted
                            }
                            RowLayout {
                                Item {
                                    Layout.fillWidth: true
                                }
                                RowLayout {
                                    visible: card.modelData.actions.length > 0
                                    spacing: 4

                                    Repeater {
                                        model: card.modelData.actions

                                        delegate: Rectangle {
                                            implicitWidth: actionText.width + 25
                                            implicitHeight: 25
                                            visible: card.modelData.actions.length > 0
                                            color: actionMouse.containsPress ? Config.colors.accent : Config.colors.bgLight
                                            radius: 90
                                            border {
                                                width: 2
                                                color: actionMouse.containsMouse ? Config.colors.accent : "transparent"
                                            }
                                            Text {
                                                id: actionText
                                                anchors.centerIn: parent
                                                text: modelData.text
                                                color: Config.colors.text
                                            }
                                            MouseArea {
                                                id: actionMouse
                                                anchors.fill: parent
                                                onClicked: modelData.invoke()
                                                hoverEnabled: true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    MouseArea {
                        id: mouse
                        hoverEnabled: true
                    }
                }
            }
        }
    }
}
