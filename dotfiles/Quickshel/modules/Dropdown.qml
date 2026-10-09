import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

Item {
    id: root

    property var model: []
    property int currentIndex: 0
    property var textRole: item => item.toString()
    property string placeholder: "Select..."

    property int itemHeight: 28
    property string direction: "down"   // "down" or "up"

    signal selected(int index)

    implicitHeight: itemHeight
    z: 10

    property bool expanded: false
    readonly property var currentItem: (currentIndex >= 0 && currentIndex < model.length) ? model[currentIndex] : null

    Rectangle {
        id: header
        anchors.fill: parent
        color: Config.colors.bgDark
        radius: 8
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 0

            Text {
                Layout.fillWidth: true
                text: root.currentItem !== null ? root.textRole(root.currentItem) : root.placeholder
                color: Config.colors.text
                elide: Text.ElideRight
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 28
                radius: 8
                    color: root.expanded ? Config.colors.accentDark : mouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : mouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bgLight, 1)
                Text {
                    text: root.expanded ? (root.direction === "up" ? "▼" : "▲") : (root.direction === "up" ? "▲" : "▼")
                    color: Config.colors.text
                    font.pixelSize: 10
                    anchors.centerIn: parent
                }
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
            hoverEnabled: true
        }
    }

    Rectangle {
        id: list
        visible: root.expanded
        anchors.left: header.left
        anchors.right: header.right
        anchors.top: root.direction === "up" ? undefined : header.bottom
        anchors.bottom: root.direction === "up" ? header.top : undefined
        anchors.topMargin: root.direction === "up" ? 0 : 2
        anchors.bottomMargin: root.direction === "up" ? 2 : 0
        height: column.implicitHeight
        color: Config.colors.bg
        radius: 8

        Column {
            id: column
            width: parent.width

            Repeater {
                model: root.model

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    radius: 8
                    width: column.width
                    height: root.itemHeight
                    color: index === root.currentIndex ? Qt.alpha(Config.colors.bgLight, 1) : "transparent"

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        verticalAlignment: Text.AlignVCenter
                        text: root.textRole(modelData)
                        color: Config.colors.text
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.selected(index);
                            root.expanded = false;
                        }
                    }
                }
            }
        }
    }
}
