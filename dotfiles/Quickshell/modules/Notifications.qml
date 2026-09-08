import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../config.js" as Config
import qs.services

Scope {
    id: root
    property bool centerOpen: false
    ListModel {
        id: history
        onCountChanged: NotificationCount.count = history.count
    }
    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: n => {
            history.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            });
            n.tracked = true;
        }
    }

    IpcHandler {
        id: ipc
        target: "notifications"
        function toggle(): void {
            root.centerOpen = !root.centerOpen;
        }
    }
    // notification center
    PanelWindow {
        id: centerPanel
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusiveZone: 0
        color: "transparent"
        visible: root.centerOpen
        MouseArea {
            anchors.fill: parent
            onClicked: ipc.hide()
        }

        PanelWindow {
            id: panel
            anchors {
                top: true
                right: true
                bottom: true
            }
            margins {
                top: 0
                right: 0
                bottom: 0
            }
            visible: centerPanel.visible
            BackgroundEffect.blurRegion: Region {
                item: panel.contentItem
            }
            WlrLayershell.keyboardFocus: root.visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None // grab keyboard focus
            WlrLayershell.layer: WlrLayer.Overlay
            exclusiveZone: 0
            implicitWidth: 380
            color: Qt.alpha(Config.colors.bgDark, 0.5)
            MouseArea {
                anchors.fill: parent
                onClicked: {}
            }
            Text {
                anchors.centerIn: parent
                visible: history.count < 1
                text: "No notifications"
                color: Config.colors.textMuted
            }
            ColumnLayout {
                id: centerCol
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                RowLayout {
                    id: headerRow
                    Layout.fillWidth: true
                    Text {
                        text: "Notifications"
                        font.bold: true
                        font.pixelSize: 16
                        color: Config.colors.text
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Rectangle {
                        implicitHeight: 20
                        implicitWidth: clearText.width + 10
                        color: history.count > 0 ? Config.colors.bg : Config.colors.bgLight
                        border {
                            width: 1
                            color: Config.colors.border
                        }
                        Text {
                            id: clearText
                            anchors.centerIn: parent
                            text: "Clear"
                            color: history.count > 0 ? Config.colors.text : Config.colors.textMuted
                            MouseArea {
                                anchors.fill: parent
                                onClicked: history.clear()
                            }
                        }
                    }
                }

                ListView {
                    id: cardCol
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 8
                    boundsBehavior: Flickable.StopAtBounds
                    model: history
                    delegate: Rectangle {
                        id: cardDelegate
                        required property string summary
                        required property string body
                        required property string appName
                        required property string time
                        required property int urgency
                        required property int index

                        width: ListView.view.width
                        height: cardLayout.implicitHeight + 20
                        color: Qt.alpha(Config.colors.bg, 0.5)
                        border.width: 1
                        border.color: urgency === NotificationUrgency.Critical ? Config.colors.red : Config.colors.border

                        ColumnLayout {
                            id: cardLayout
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 4

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 5

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 5

                                    RowLayout {
                                        Text {
                                            Layout.fillWidth: true
                                            text: cardDelegate.summary
                                            font.bold: true
                                            elide: Text.ElideRight
                                            color: Config.colors.text
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }
                                        Rectangle {
                                            Layout.alignment: Qt.AlignTop
                                            implicitHeight: 20
                                            implicitWidth: 20
                                            color: Config.colors.bgLight
                                            border {
                                                width: 1
                                                color: Config.colors.border
                                            }
                                            Text {
                                                text: "󰅖"
                                                anchors.centerIn: parent
                                                color: Config.colors.textMuted
                                                font.pixelSize: 16
                                            }
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: history.remove(cardDelegate.index)
                                            }
                                        }
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        visible: text !== ""
                                        text: cardDelegate.body
                                        wrapMode: Text.WordWrap
                                        color: Config.colors.textMuted
                                    }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        color: Config.colors.border
                                        implicitHeight: 2
                                    }
                                    RowLayout {
                                        Text {
                                            visible: cardDelegate.appName !== "Unknown app"
                                            text: cardDelegate.appName
                                            color: Config.colors.textMuted
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }
                                        Text {
                                            text: cardDelegate.time
                                            Layout.alignment: Qt.AlignTop
                                            Layout.topMargin: 3
                                            color: Config.colors.textMuted
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // single notification
    PanelWindow {
        anchors {
            top: true
            right: true
        }
        margins {
            top: 8
            right: 8
        }

        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)

        color: "transparent"

        exclusiveZone: 0

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 5

            Repeater {
                model: server.trackedNotifications
                delegate: Rectangle {
                    id: card
                    required property var modelData
                    visible: card.modelData.urgency === NotificationUrgency.Low ? false : true
                    Layout.fillWidth: true
                    Layout.preferredHeight: layout.implicitHeight + 20
                    color: Qt.alpha(Config.colors.bgDark, 0.5)
                    border.width: 1
                    border.color: card.modelData.urgency === NotificationUrgency.Critical ? Config.colors.red : Config.colors.border
                    clip: true
                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
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
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5

                            RowLayout {
                                Text {
                                    Layout.fillWidth: true
                                    text: card.modelData.summary
                                    font.bold: true
                                    elide: Text.ElideRight
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
                                    color: Config.colors.bgLight
                                    border {
                                        width: 1
                                        color: Config.colors.border
                                    }
                                    Text {
                                        text: "󰅖"
                                        anchors.centerIn: parent
                                        color: Config.colors.textMuted
                                        font.pixelSize: 16
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: card.modelData.dismiss()
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
                            Rectangle {
                                Layout.fillWidth: true
                                color: Config.colors.border
                                implicitHeight: 2
                            }
                            RowLayout {
                                Text {
                                    visible: card.modelData.appName !== "Unknown app"
                                    text: card.modelData.appName
                                    color: Config.colors.textMuted
                                }
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
                                            color: Qt.alpha(Config.colors.bg, 0.5)
                                            border {
                                                width: 1
                                                color: Config.colors.border
                                            }
                                            Text {
                                                id: actionText
                                                anchors.centerIn: parent
                                                text: modelData.text
                                                color: Config.colors.text
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
