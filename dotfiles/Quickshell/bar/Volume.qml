import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
Text {
    id: sound
    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }
    property var node: Pipewire.defaultAudioSink
    property bool ready: node.ready
    property var volume: Math.trunc(node.audio.volume * 100)
    text: volume + "%"

}
