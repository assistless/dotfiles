import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import qs
import qs.modules

Rectangle {
    implicitHeight: 20
    implicitWidth: mouse.containsMouse ? 200 : Math.min(row.implicitWidth + 10, 200)
    radius: 10
    clip: true
    color: Config.colors.bgLight
    visible: activeToplevel
    Behavior on implicitWidth {
        NumberAnimation {
            id: animation
            duration: 245
            easing.type: Easing.InOutQuad
        }
    }
    property var activeToplevel: ToplevelManager.activeToplevel
    RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        IconImage {
            source: activeToplevel ? Quickshell.iconPath(DesktopEntries.heuristicLookup(activeToplevel.appId ?? "")?.icon) ?? "" : ""
            implicitSize: 12
            visible: true
        }
        Text {
            text: activeToplevel ? DesktopEntries.heuristicLookup(activeToplevel?.appId ?? "")?.name ?? activeToplevel?.appId ?? "" : ""
            font.pixelSize: 12
            Layout.fillWidth: true
            color: Config.colors.text
            visible: !mouse.containsMouse
            opacity: mouse.containsMouse ? 0 : 1
            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                }
            }
        }
        OverflowText {
            id: overflowText
            text: activeToplevel ? activeToplevel.title : ""
            opacity: mouse.containsMouse ? 1 : 0
            size: 12
            Layout.fillWidth: true
            color: Config.colors.text
            visible: mouse.containsMouse
            active: !animation.running
            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                }
            }
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onHoveredChanged: overflowText.restart()
    }
}
