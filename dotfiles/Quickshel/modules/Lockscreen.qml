import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import "../config.js" as Config

ShellRoot {
    WlSessionLock {
        id: lock
        locked: false
        WlSessionLockSurface {
            Rectangle {
                id: root
                anchors.fill: parent
                color: Config.colors.bgDark

                Image {
                    source: "file://" + Quickshell.shellPath("wallpaper.jpg")
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                    anchors.fill: parent
                }
                Rectangle {
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        bottomMargin: 182
                        rightMargin: 10
                    }
                    implicitHeight: 22
                    implicitWidth: 128
                    color: Config.colors.bg
                    Text {
                        anchors.centerIn: parent
                        text: (Globals.notificationCount == 0 ? "No" : Globals.notificationCount) + " new notifications"
                        color: Config.colors.text
                    }
                }
                PamContext {
                    id: pam
                    config: "quickshell"

                    onPamMessage: {
                        if (responseRequired) {
                            respond(pwField.text);
                        }
                    }

                    onCompleted: result => {
                        if (result === PamResult.Success) {
                            lock.locked = false;
                        } else {
                            pwField.text = "";
                            pwField.enabled = true;
                        }
                    }

                    onError: error => {
                        pwField.enabled = true;
                    }
                }

                Rectangle {
                    id: bottomPanel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    color: Config.colors.bg
                    implicitHeight: expanded ? parent.height : 175
                    clip: true

                    property bool expanded: false

                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutCubic
                        }
                    }

                    RowLayout {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 175
                        ColumnLayout {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                            Layout.leftMargin: 50
                            spacing: 10
                            Text {
                                text: Time.timeDisplay
                                color: Config.colors.text
                                font.pixelSize: 48
                            }
                            Text {
                                text: Time.dateDisplay
                                color: Config.colors.text
                                font.pixelSize: 16
                            }
                        }
                        ColumnLayout {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                            Layout.rightMargin: 25
                            Layout.maximumWidth: 400
                            SongInfo {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.topMargin: 10
                                layoutMode: "compact"
                                artSize: 125
                                reversed: true
                                visible: player ? true : false
                            }
                        }
                    }

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        width: 50
                        height: 100
                        bottomLeftRadius: 50
                        bottomRightRadius: 50
                        color: Config.colors.accent
                    }
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 5
                        bottomLeftRadius: 50
                        bottomRightRadius: 50
                        color: Config.colors.accent
                    }
                    Rectangle {
                        id: iconUp
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        width: 50
                        height: 50
                        bottomLeftRadius: 50
                        bottomRightRadius: 50
                        color: Config.colors.accent
                        Text {
                            text: ""
                            color: Config.colors.text
                            font.pixelSize: 24
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle {
                        id: icon
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 50
                        width: 50
                        height: 50
                        bottomLeftRadius: 50
                        bottomRightRadius: 50
                        color: Config.colors.accent
                        Text {
                            text: "󰌾"
                            color: Config.colors.text
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -2
                            anchors.horizontalCenterOffset: 1
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: bottomPanel.expanded = !bottomPanel.expanded
                        }
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        opacity: bottomPanel.expanded ? 1 : 0
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                            }
                        }

                        Text {
                            color: Config.colors.text
                            text: pam.message ? pam.message : "Password: "
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Rectangle {
                            width: 220
                            height: 36
                            color: Config.colors.bg
                            border.color: Config.colors.border
                            border.width: 1
                            radius: 20
                            Layout.alignment: Qt.AlignHCenter
                            TextInput {
                                id: pwField
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                verticalAlignment: TextInput.AlignVCenter
                                color: Config.colors.text
                                font.pixelSize: 14
                                echoMode: TextInput.Password
                                clip: true
                                focus: bottomPanel.expanded
                                onAccepted: {
                                    enabled = false;
                                    pam.start();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    IpcHandler {
        target: "lock"
        function lock(): void {
            lock.locked = true;
        }
    }
}
