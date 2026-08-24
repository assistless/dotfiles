import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "../config.js" as Config

Text {
    id: sound
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    property var node: Pipewire.defaultAudioSink
    property bool ready: node.ready
    property var volume: Math.round(node.audio.volume * 100)
    text: volume + "%"
    color: Config.colors.text
    MouseArea {
        anchors.fill:parent
        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "0.01+"])
            } else if (wheel.angleDelta.y < 0) {
                Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "0.01-"])
            }
            wheel.accepted = true 
        }
    }
}
