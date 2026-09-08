// Launcher.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import "../config.js" as Config

PanelWindow {
    id: root
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusiveZone: 0
    color: "transparent"
    visible: false
    MouseArea {
        anchors.fill: parent
        onClicked: root.hide()
    }

    function hide() {
        root.visible = false;
        search.text = "";
    }
    function show() {
        root.visible = true;
        search.forceActiveFocus();
    }
    IpcHandler {
        target: "launcher"
        function toggle() {
            if (root.visible)
                root.hide();
            else
                root.show();
        }
    }

    property var filteredApps: {
        const q = search.text.toLowerCase();
        const all = DesktopEntries.applications.values;
        if (q.length === 0)
            return all;
        return all.filter(app => app.name.toLowerCase().includes(q));
    }

    PanelWindow {
        id: launcher
        anchors {
            top: true
            right: true
            bottom: true
        }
        margins {
            top: 8
            right: 8
            bottom: 8
        }
        visible: root.visible
        WlrLayershell.keyboardFocus: root.visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None // grab keyboard focus
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0
        implicitWidth: 380
        color: Qt.alpha(Config.colors.bgDark, 0.5)
        BackgroundEffect.blurRegion: Region {
            item: launcher.contentItem
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {} // eat clicks so they don't fall through
        }

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            Text {
                text: "Apps"
                font.bold: true
                color: Config.colors.text
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                color: Qt.alpha(Config.colors.bgLight, 0.5)
                implicitHeight: 25
                
                TextInput {
                    id: search
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    echoMode: TextInput.Normal
                    selectByMouse: true
                    color: Config.colors.text
                    font.pixelSize: 14

                    Keys.onEscapePressed: root.hide()
                    Keys.onReturnPressed: {
                        if (appList.count > 0) {
                            const app = root.filteredApps[0];
                            app.execute();
                            root.hide();
                        }
                    }
                }
            }

            ListView {
                id: appList
                width: parent.width
                height: parent.height - 55
                clip: true
                spacing: 2
                model: root.filteredApps
                boundsBehavior: Flickable.StopAtBounds
                delegate: Rectangle {
                    width: appList.width
                    implicitHeight: 36
                    color: mouseArea.containsMouse ? Qt.alpha(Config.colors.accent, 0.5) : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 6
                        anchors.rightMargin: 6
                        spacing: 8

                        IconImage {
                            source: Quickshell.iconPath(modelData.icon, true)
                            implicitWidth: 20
                            implicitHeight: 20
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: modelData.name
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            color: mouseArea.containsMouse ? Config.colors.text : Config.colors.textMuted
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            modelData.execute();
                            root.hide();
                        }
                    }
                }
            }
        }
    }
}
