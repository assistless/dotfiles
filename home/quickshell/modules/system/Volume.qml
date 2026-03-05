import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Wayland
import "../../assets"
Scope {
    id: root

    // Bind the pipewire node so its volume will be tracked
    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
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
        active: true

        PanelWindow {
            // Since the panel's screen is unset, it will be picked by the compositor
            // when the window is created. Most compositors pick the current active monitor.

            anchors {
                bottom: true
            }
            margins {
                bottom: 10
            }
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Overlay
            implicitWidth: 400
            implicitHeight: 50
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                color: Qt.alpha(Theme.crust,0.9)
                radius: 10
                border {
                    width: 1
                    color: Theme.accent
                }
                opacity: root.shouldShowOsd ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 15
                    }

                    Text {
                        font.pixelSize: 30
                        text: " "
                        color: Theme.overlay2
                    }

                    Rectangle {
                        // Stretches to fill all left-over space
                        Layout.fillWidth: true
                        radius: 10
                        implicitHeight: 10
                        color: Theme.overlay0

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }
                            radius: 10
                            color: Theme.accent
                            implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
                        }
                    }
                }
            }
        }
    }
}
