import QtQuick
import "../config.js" as Config

Item {
    id: root
    property real from: 0
    property real to: 1
    property real value: 0.5
    signal moved(real newValue)

    property int handleWidth: 15
    property int handleHeight: 15
    property real edgeInsetRatio: 0.5
    readonly property real edgeInset: handleWidth * edgeInsetRatio

    implicitHeight: Math.max(handleHeight, 10)

    readonly property real _range: to - from
    function _toFraction(v) {
        return _range !== 0 ? Math.max(0, Math.min(1, (v - from) / _range)) : 0;
    }
    function _fromFraction(f) {
        return from + f * _range;
    }

    property bool isDragging: dragArea.pressed

    Rectangle {
        id: track
        width: root.width
        height: 10
        anchors.verticalCenter: parent.verticalCenter
        radius: 5
        color: Config.colors.textMuted

        Rectangle {
            id: fill
            width: track.width * root._toFraction(root.value)
            height: track.height
            radius: track.radius
            topRightRadius: 0
            bottomRightRadius: 0
            color: Config.colors.accent
        }
    }

    Rectangle {
        id: handle
        width: root.handleWidth
        height: root.handleHeight
        radius: root.handleWidth / 2
        color: Config.colors.text
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1
        x: (track.width - width) * root._toFraction(root.value)
        border {
            color: Config.colors.accent
            width: 2
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent

        function updateValue(mouseX) {
            const clampedX = Math.max(0, Math.min(track.width, mouseX));
            const fraction = track.width > 0 ? clampedX / track.width : 0;
            root.moved(root._fromFraction(fraction));
        }

        onPressed: mouse => updateValue(mouse.x)
        onPositionChanged: mouse => {
            if (pressed)
                updateValue(mouse.x);
        }
    }
}
