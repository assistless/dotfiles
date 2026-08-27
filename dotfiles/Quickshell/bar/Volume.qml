import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "../config.js" as Config

Rectangle {
    color: "transparent"
    height: 20
    anchors.left: parent.left
    anchors.right: parent.right
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
    Text {
        id: soundIcon
        anchors.centerIn: parent
        text: "󰕾"
        visible: !mouseArea.containsMouse
        color: Config.colors.text
        MouseArea {
            anchors.fill: parent
            onWheel: wheel => {
                if (wheel.angleDelta.y > 0) {
                    Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "0.01+"]);
                } else if (wheel.angleDelta.y < 0) {
                    Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "0.01-"]);
                }
                wheel.accepted = true;
            }
        }
    }
    Text {
        id: sound
        anchors.centerIn: parent
        PwObjectTracker {
            objects: [Pipewire.defaultAudioSink]
        }
        property var node: Pipewire.defaultAudioSink
        property bool ready: node.ready
        property var volume: Math.round(node.audio.volume * 100)
        text: volume + "%"
        font.pixelSize: 11
        visible: mouseArea.containsMouse
        color: Config.colors.text
        MouseArea {
            anchors.fill: parent
            onWheel: wheel => {
                if (wheel.angleDelta.y > 0) {
                    Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "0.01+"]);
                } else if (wheel.angleDelta.y < 0) {
                    Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "0.01-"]);
                }
                wheel.accepted = true;
            }
        }
    }
}
