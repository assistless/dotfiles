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
        function show(): void {
            root.centerOpen = true;
        }
        function hide(): void {
            root.centerOpen = false;
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
        WlrLayershell.layer: WlrLayer.Overlay
        color: "transparent"
        visible: root.centerOpen
        MouseArea {
            anchors.fill: parent
            onClicked: ipc.hide()
        }

        Rectangle {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 8
            implicitWidth: 380
            clip: true
            property int emptyHeight: 120
            property int maxHeight: 420
            height: Math.min(Math.max(emptyHeight, headerRow.implicitHeight + centerCol.spacing + cardCol.contentHeight + 20), maxHeight)
            border {
                color: Config.colors.border
                width: 1
            }
            color: Config.colors.bgDark
            MouseArea {
                anchors.fill: parent
                onClicked: {}
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
                    Text {
                        text: "Clear all"
                        color: Config.colors.textMuted
                        visible: history.count > 0
                        MouseArea {
                            anchors.fill: parent
                            onClicked: history.clear()
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
                        color: Config.colors.bg
                        border.width: 1
                        border.color: urgency === NotificationUrgency.Critical ? Config.colors.warn : Config.colors.border

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

                                    Text {
                                        Layout.fillWidth: true
                                        text: cardDelegate.summary
                                        font.bold: true
                                        elide: Text.ElideRight
                                        color: Config.colors.text
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
                                    Text {
                                        visible: cardDelegate.appName !== ""
                                        text: cardDelegate.appName
                                        color: Config.colors.textMuted
                                    }
                                }
                                Text {
                                    text: cardDelegate.time
                                    Layout.alignment: Qt.AlignTop
                                    color: Config.colors.textMuted
                                }
                                Text {
                                    text: "x"
                                    Layout.alignment: Qt.AlignTop
                                    color: Config.colors.textMuted
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: history.remove(cardDelegate.index)
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
            top: 12
            right: 12
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

                    Layout.fillWidth: true
                    Layout.preferredHeight: layout.implicitHeight + 20
                    color: Config.colors.bg
                    border.width: 2
                    border.color: urgency === NotificationUrgency.Critical ? Config.colors.warn : Config.colors.border

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

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                font.bold: true
                                elide: Text.ElideRight
                                color: Config.colors.text
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
                                    text: "Click to dismiss"
                                    color: Config.colors.text
                                }
                                Item {
                                    Layout.fillWidth: true
                                }
                                Text {
                                    visible: card.modelData.appName !== ""
                                    text: card.modelData.appName
                                    color: Config.colors.textMuted
                                }
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }
}
