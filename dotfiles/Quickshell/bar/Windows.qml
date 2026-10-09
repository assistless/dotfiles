import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs
import qs.modules

RowLayout {
    spacing: 4
    Repeater {
        model: ToplevelManager.toplevels
        Rectangle {
            id: pill
            height: 20
            radius: 20
            color: mouse.containsPress ? Config.colors.accent : Config.colors.bgLight
            Layout.preferredWidth: icon.implicitWidth + 10
            border {
              width: 2
              color: modelData === ToplevelManager.activeToplevel ? Config.colors.accent : mouse.containsMouse ? Config.colors.accent : "transparent"
            }

            RowLayout {
                id: icon
                anchors.centerIn: parent
                spacing: modelData === ToplevelManager.activeToplevel ? 3 : mouse.containsMouse ? 3 : 0

                IconImage {
                    Layout.alignment: Qt.AlignCenter
                    source: Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData?.appId ?? "")?.icon) ?? ""
                    implicitSize: 12
                }

                Text {
                    text: DesktopEntries.heuristicLookup(modelData?.appId ?? "")?.name ?? modelData?.appId ?? ""
                    color: Config.colors.text
                    opacity: modelData === ToplevelManager.activeToplevel ? 1 : mouse.containsMouse ? 1 : 0
                    font.pixelSize: 12
                    Layout.preferredWidth: modelData === ToplevelManager.activeToplevel ? implicitWidth : mouse.containsMouse ? implicitWidth : 0
                    clip: true

                    Behavior on Layout.preferredWidth {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.InOutQuad
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                onClicked: modelData.activate()
                hoverEnabled: true
            }
        }
    }
}
