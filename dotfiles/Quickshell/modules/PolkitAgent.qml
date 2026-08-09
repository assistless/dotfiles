import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Polkit
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Scope {
    id: root
    // load as needed
    LazyLoader {
        active: polkitAgent.isActive
        PanelWindow {
            mask: Region { item: popup }

            anchors {
                top: true
                left: true
                bottom: true
                right: true
            }
            exclusionMode: ExclusionMode.Ignore

            color: Qt.alpha("#000000", 0.25) // screen dimming

            WlrLayershell.keyboardFocus: polkitAgent.isActive ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None // grab keyboard focus

            WlrLayershell.layer: WlrLayer.Overlay

            visible: true

            // attempt authentication
            function proceedAuth() {
                polkitAgent.flow.submit(passwordInput.text)
                passwordInput.text = ""
                passwordInput.forceActiveFocus()
            }
            // self-explanatory
            function cancelAuth() {
                polkitAgent.flow.cancelAuthenticationRequest()
                passwordInput.text = ""
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
                color: "lightgray"

                // content
                ColumnLayout {
                    id: contentColumn
                    anchors.centerIn: parent
                    spacing: 12

                    Item { Layout.fillHeight: true }

                    Label {
                        Layout.fillWidth: true
                        text: polkitAgent.flow?.message || "* But no message came."
                        wrapMode: Text.Wrap
                        font.bold: true
                    }

                    Label {
                        Layout.fillWidth: true
                        text: polkitAgent.flow?.supplementaryMessage || "* But no message came."
                        wrapMode: Text.Wrap
                        opacity: 0.8
                    }

                    Label {
                        Layout.fillWidth: true
                        text: polkitAgent.flow?.inputPrompt || "Authenticating..."
                        wrapMode: Text.Wrap
                    }

                    Label {
                        text: "Authentication failed, try again"
                        color: "red"
                        visible: polkitAgent.flow?.failed
                    }
                    // password input
                    Rectangle {
                        width: 500
                        height: 25
                        TextInput {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            id: passwordInput
                            echoMode: polkitAgent.flow?.responseVisible
                            ? TextInput.Normal : TextInput.Password
                            selectByMouse: true
                            Layout.fillWidth: true
                            onAccepted: proceedAuth()
                            Component.onCompleted: passwordInput.forceActiveFocus()
                        }
                    }

                    RowLayout {
                        spacing: 8
                        // ok button
                        Rectangle {
                            implicitHeight: 22
                            implicitWidth: 52
                            enabled: passwordInput.text.length > 0 || !!polkitAgent.flow?.isResponseRequired
                            MouseArea {
                                id: okButton
                                anchors.fill: parent
                                onClicked: proceedAuth()
                            }
                            Text {
                                text: "OK"
                                anchors.centerIn: parent
                            }
                        }
                        // cancel button
                        Rectangle {
                            implicitHeight: 22
                            implicitWidth: 52
                            visible: polkitAgent.isActive
                            Text {
                                anchors.centerIn: parent
                                text: "Cancel"
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: cancelAuth()
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }

            Connections {
                target: polkitAgent.flow
                function onIsResponseRequiredChanged() {
                    passwordInput.text = ""
                    if (polkitAgent.flow.isResponseRequired)
                        passwordInput.forceActiveFocus()
                }
            }
        }
    }

    PolkitAgent {
        id: polkitAgent
    }
}
