import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../core"
Rectangle {
    anchors.margins: 0
    width: row.childrenRect.width + 5
    height: row.childrenRect.height + 5
    color: Theme.isDark ? Qt.alpha("white", 0) : Theme.text
    radius: Config.data.bar.radius
    Row {
        id: row
        spacing: 5
        anchors.centerIn: parent
        Repeater {
            model: SystemTray.items

            Item {
                id: iconContainer
                required property SystemTrayItem modelData
                height: 20
                implicitWidth: 20
                IconImage {
                    id: icon
                    source: iconContainer.modelData.icon
                    implicitSize: 16
                    anchors.centerIn: parent
                }

                ToolTip {
                    id: toolTip
                    popupType: Popup.Native
                    delay: 500

                    contentItem: Text {
                        text: toolTip.text
                        color: Theme.text
                    }
                    background: Rectangle {
                        color: Theme.crust
                        radius: 0
                    }
                }

                QsMenuAnchor {
                    id: menuAnchor
                    anchor.item: iconContainer
                    anchor.gravity: Edges.Top | Edges.Center
                    menu: iconContainer.modelData.menu
                }

                MouseArea {
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    hoverEnabled: true
                    anchors.fill: parent

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton)
                            iconContainer.modelData.activate();
                        else if (mouse.button === Qt.RightButton)
                            menuAnchor.open();
                    }

                    onEntered: {
                        if (iconContainer.modelData.tooltipTitle === "")
                            return;

                        toolTip.show(iconContainer.modelData.tooltipTitle);
                    }

                    onExited: toolTip.hide()
                }
            }
        }
    }
}
