import QtQuick
import QtQuick.Layouts
import qs

Item {
    id: root
    implicitHeight: titleText.implicitHeight
    clip: true
    property string text: ""
    property string color: ""
    property int size: 12
    property bool title: false
    property int horizontalAlignment: Text.AlignLeft   // Text.AlignLeft / AlignRight / AlignHCenter
    readonly property real overflow: Math.max(0, titleText.implicitWidth - root.width)
    property bool active: true
    property real gap: 40

    function restart() {
        scrollingAnim.restart()
    }

    Row {
        id: row
        spacing: root.gap
        anchors.verticalCenter: parent.verticalCenter

        NumberAnimation on x {
            id: scrollingAnim
            running: root.overflow > 0 && root.active
            loops: Animation.Infinite
            from: 0
            to: -(titleText.implicitWidth + root.gap)
            duration: (titleText.implicitWidth + root.gap) * 30
        }

        Binding {
            target: row
            property: "x"
            when: root.overflow === 0
            value: {
                if (root.horizontalAlignment === Text.AlignRight)
                    return root.width - titleText.implicitWidth;
                if (root.horizontalAlignment === Text.AlignHCenter)
                    return (root.width - titleText.implicitWidth) / 2;
                return 0;
            }
        }

        Text {
            id: titleText
            text: root.text
            color: root.color
            font.pixelSize: root.size
            font.bold: root.title
        }
        Text {
            text: titleText.text
            color: titleText.color
            font: titleText.font
            visible: root.overflow > 0
        }
    }
}