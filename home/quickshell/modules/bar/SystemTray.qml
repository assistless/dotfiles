import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../../assets"

Row {
    spacing: 5

    Repeater {
        model: SystemTray.items

        Item {
            id: iconContainer
            required property SystemTrayItem modelData
            width: 20
            height: 20

            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                color: Theme.overlay2
                radius: 15
            }

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
