import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "../config.js" as Config

Scope {
    id: root

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property bool shouldShowOsd: false

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    // The OSD window will be created and destroyed based on shouldShowOsd.
    // PanelWindow.visible could be set instead of using a loader, but using
    // a loader will reduce the memory overhead when the window isn't open.
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            // Since the panel's screen is unset, it will be picked by the compositor
            // when the window is created. Most compositors pick the current active monitor.

            anchors.top: true
            margins.top: 0
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Overlay
            implicitWidth: 400
            implicitHeight: 50
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}
            Rectangle {
                id: osd
                anchors.fill: parent
                color: Qt.alpha(Config.colors.bgDark, 0.5)
                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 18
                    }

                    IconImage {
                        implicitSize: 30
                        source: Quickshell.iconPath("audio-volume-high-symbolic")
                    }

                    Rectangle {
                        // Stretches to fill all left-over space
                        Layout.fillWidth: true

                        implicitHeight: 20
                        color: Config.colors.textMuted

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }
                            color: Config.colors.text
                            implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignRight
                        Layout.maximumWidth: 25
                        text: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100) + "%"
                        color: Config.colors.text
                    }
                }
            }
        }
    }
}
