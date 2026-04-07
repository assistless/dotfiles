import Quickshell
import Quickshell.Wayland
import QtQuick
import QtMultimedia
import "../core"
ShellRoot {
    PanelWindow {
    anchors.left: true
    anchors.right: true
    anchors.top: true
    anchors.bottom: true
    id: root
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusiveZone: -1
    Quote {}
    color: "black"

    readonly property string path: Config.data.wallpaper.path

    readonly property bool isVideo: {
        const ext = path.split('.').pop().toLowerCase()
        return ["mp4", "mkv", "webm", "avi", "mov"].includes(ext)
    }

    Image {
        anchors.fill: root
        source: !root.isVideo && root.path ? "file://" + root.path : ""
        fillMode: Image.PreserveAspectCrop
        visible: !root.isVideo
        cache: false
        asynchronous: true
    }

    MediaPlayer {
        id: player
        source: root.isVideo && root.path ? "file://" + root.path : ""
        videoOutput: videoOut
        audioOutput: AudioOutput { volume: 0.0 }
        loops: MediaPlayer.Infinite
        onSourceChanged: if (source != "") play()
    }

    VideoOutput {
        id: videoOut
        anchors.fill: parent
        visible: root.isVideo
    }
}
}
