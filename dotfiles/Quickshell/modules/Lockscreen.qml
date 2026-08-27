import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../config.js" as Config

ShellRoot {
    WlSessionLock {
        id: lock
        locked: true
        WlSessionLockSurface {
            Rectangle {
                anchors.fill: parent
                color: Config.colors.bgDark
                Image {
                    source: "file://" + Quickshell.shellPath("wallpaper.jpg")
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                    anchors.fill: parent
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
                    anchors.centerIn: parent
                    color: Config.colors.bgDark
                    implicitHeight: 250
                    implicitWidth: 500
                    border {
                        color: Config.colors.border
                        width: 1
                    }
                    RowLayout {
                        anchors.fill: parent
                        ColumnLayout {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                            Layout.leftMargin: 50
                            spacing: 15

                            Text {
                                text: Qt.formatDateTime(new Date(), "hh:mm")
                                color: Config.colors.text
                                font.pixelSize: 48
                            }
                        }
                        ColumnLayout {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                            Layout.rightMargin: 50
                            spacing: 15
                            Text {
                                color: Config.colors.text
                                text: pam.message ? pam.message : "Password: "
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            }
                            Rectangle {
                                width: 220
                                height: 36
                                color: Config.colors.bg
                                border.color: Config.colors.border
                                border.width: 1
                                radius: 0
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                TextInput {
                                    id: pwField
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    verticalAlignment: TextInput.AlignVCenter
                                    color: Config.colors.text
                                    font.pixelSize: 14
                                    echoMode: TextInput.Password
                                    clip: true

                                    focus: true
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
    }
    IpcHandler {
        target: "lock"
        function lock(): void {
            lock.locked = true;
        }
    }
}
