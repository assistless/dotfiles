import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../core"
import "../../assets"
PanelWindow {
    id: bar
    anchors {
        bottom: true
        left: true
        right: true
    }
    implicitHeight: Config.data.bar.size
    color: "transparent"
    property int barEdgeSize : 8
    PanelWindow {
        anchors {
            left: true
            bottom: true
            top: true
        }
        implicitWidth: bar.barEdgeSize
        Rectangle {
            id: barRecLeft
            anchors.fill: parent
            color: Qt.alpha(Theme.crust, 0.9)
        }
    }
    PanelWindow {
    anchors {
        right: true
        bottom: true
        top: true
    }
    implicitWidth: bar.barEdgeSize
    Rectangle {
        id: barRecRight
        anchors.fill: parent
        color: Qt.alpha(Theme.crust, 0.9)
    }
    }
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: bar.barEdgeSize
        Rectangle {
            id: barRectTop
            anchors.fill: parent
            color: Qt.alpha(Theme.crust, 0.9)
        }
    }
    Rectangle {
        id: barRec
        anchors.fill: parent
        color: Qt.alpha(Theme.crust, 0.9)

        RowLayout {
            id: barContentLayout
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Loader { active: true; sourceComponent: Workspaces {} }
            }
            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Loader { active: true; sourceComponent: FocusedWindow {} }
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 12
                Loader { active: true; sourceComponent: SystemTray {} }
                Loader { active: true; sourceComponent: Power {} }
                Loader { active: true; sourceComponent: Time {} }
                Loader { active: true; sourceComponent: PowerButton {} }
            }
        }
    }
}

