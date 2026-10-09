import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

Scope {
    id: root
    property bool visible: true
    LazyLoader {
        active: root.visible
        PanelWindow {
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
            PanelWindow {
                id: appMenu
                anchors {
                    top: true
                }
                width: 500
                height: 500
                color: Config.colors.bg
                WlrLayershell.keyboardFocus: root.visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
                property string searchText: ""
                property var filteredEntries: DesktopEntries.applications.values.filter(e => e.name.toLowerCase().includes(searchText.toLowerCase())).sort((a, b) => a.name.localeCompare(b.name))
                exclusiveZone: 0
                WlrLayershell.layer: WlrLayer.Overlay
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 6

                    Rectangle {
                        Layout.fillWidth: true
                        height: 28
                        radius: 5
                        color: Config.colors.bgLight

                        TextInput {
                            anchors.fill: parent
                            anchors.margins: 6
                            color: "white"
                            onTextChanged: appMenu.searchText = text
                        }
                    }

                    GridView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: appMenu.filteredEntries
                        cellWidth: 80
                        cellHeight: 80
                        boundsBehavior: Flickable.StopAtBounds
                        delegate: Rectangle {
                            id: entry
                            width: GridView.view.cellWidth
                            height: GridView.view.cellHeight
                            color: mouse.containsPress ? Config.colors.accent : "transparent"
                            radius: 5
                            border {
                                width: 2
                                color: mouse.containsMouse ? Config.colors.accent : "transparent"
                            }
                            ColumnLayout {
                                anchors.fill: parent
                                IconImage {
                                    Layout.alignment: Qt.AlignHCenter
                                    implicitSize: 40
                                    source: Quickshell.iconPath(modelData.icon) ?? ""
                                }
                                Text {
                                    text: modelData.name
                                    Layout.alignment: Qt.AlignLeft
                                    Layout.leftMargin: 8
                                    Layout.bottomMargin: 5
                                    elide: Text.ElideRight
                                    Layout.preferredWidth: 70
                                    font.pixelSize: 10
                                    color: Config.colors.text
                                }
                            }

                            MouseArea {
                                id: mouse
                                anchors.fill: parent
                                onClicked: {
                                    modelData.execute();
                                    Qt.quit();
                                }
                                hoverEnabled: true
                            }
                        }
                    }
                }
            }
        }
    }
}
