import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Polkit
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../config.js" as Config

Scope {
    id: scope
    
    // load as needed
    LazyLoader {
        active: polkitAgent.isActive
        PanelWindow {
            id: root
            mask: Region {
                item: popup
            }
            BackgroundEffect.blurRegion: Region { item: root.contentItem }
            anchors {
                top: true
                left: true
                bottom: true
                right: true
            }
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"
            WlrLayershell.keyboardFocus: polkitAgent.isActive ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None // grab keyboard focus

            WlrLayershell.layer: WlrLayer.Overlay

            visible: true

            // attempt authentication
            function proceedAuth() {
                polkitAgent.flow.submit(passwordInput.text);
                passwordInput.text = "";
                passwordInput.forceActiveFocus();
            }
            // self-explanatory
            function cancelAuth() {
                polkitAgent.flow.cancelAuthenticationRequest();
                passwordInput.text = "";
            }
            // the prompt itself
            Rectangle {
                id: popup

                // align vertically and stretch horizonally
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                implicitHeight: 225
                visible: true
                color: Config.colors.bgDark

                // content
                ColumnLayout {
                    id: contentColumn
                    anchors.centerIn: parent
                    spacing: 12

                    Item {
                        Layout.fillHeight: true
                    }

                    Label {
                        Layout.fillWidth: true
                        text: polkitAgent.flow?.message || "* But no message came."
                        wrapMode: Text.Wrap
                        font.bold: true
                        color: Config.colors.text
                    }

                    Label {
                        Layout.fillWidth: true
                        text: polkitAgent.flow?.supplementaryMessage || "* But no message came."
                        wrapMode: Text.Wrap
                        opacity: 0.8
                        color: Config.colors.textMuted
                    }

                    Label {
                        Layout.fillWidth: true
                        text: polkitAgent.flow?.inputPrompt || "Authenticating..."
                        wrapMode: Text.Wrap
                        color: Config.colors.text
                    }

                    Label {
                        text: "Authentication failed, try again"
                        color: Config.colors.red
                        visible: polkitAgent.flow?.failed
                    }
                    // password input
                    Rectangle {
                        width: 500
                        height: 25
                        color: Config.colors.bg
                        TextInput {
                            id: passwordInput
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            echoMode: polkitAgent.flow?.responseVisible ? TextInput.Normal : TextInput.Password
                            selectByMouse: true
                            Layout.fillWidth: true
                            onAccepted: proceedAuth()
                            Component.onCompleted: passwordInput.forceActiveFocus()
                            color: Config.colors.text
                        }
                    }

                    RowLayout {
                        spacing: 8
                        // ok button
                        Rectangle {
                            implicitHeight: 22
                            implicitWidth: 52
                            enabled: passwordInput.text.length > 0 || !!polkitAgent.flow?.isResponseRequired
                            color: Config.colors.bg
                            MouseArea {
                                id: okButton
                                anchors.fill: parent
                                onClicked: proceedAuth()
                            }
                            Text {
                                text: "OK"
                                anchors.centerIn: parent
                                color: Config.colors.text
                            }
                        }
                        // cancel button
                        Rectangle {
                            implicitHeight: 22
                            implicitWidth: 52
                            visible: polkitAgent.isActive
                            color: Config.colors.bg
                            Text {
                                anchors.centerIn: parent
                                text: "Cancel"
                                color: Config.colors.text
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: cancelAuth()
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            Connections {
                target: polkitAgent.flow
                function onIsResponseRequiredChanged() {
                    passwordInput.text = "";
                    if (polkitAgent.flow.isResponseRequired)
                        passwordInput.forceActiveFocus();
                }
            }
        }
    }

    PolkitAgent {
        id: polkitAgent
    }
}
