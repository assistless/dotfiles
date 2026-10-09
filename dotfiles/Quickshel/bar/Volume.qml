import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import qs.modules
import "../config.js" as Config

Rectangle {
    id: root
    color: slider.visible ? Config.colors.accentDark : mouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : mouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : mouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bg, 1)
    height: 20
    width: 20
    radius: 10
    function toggle() {
        slider.visible = !slider.visible
    }
    Text {
        id: soundIcon
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -0.5
        text: ""
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
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    PanelWindow {
        id: slider
        exclusiveZone: 0
        anchors {
            bottom: true
            right: true
        }
        visible: false
        implicitHeight: 30
        implicitWidth: 200
        color: Qt.alpha(Config.colors.bg, 1)
        BackgroundEffect.blurRegion: Region {
            item: slider.contentItem
        }
        RowLayout {
            anchors.fill: parent
            Slider {
                height: 15
                Layout.alignment: Qt.AlignLeft
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.maximumWidth: 200
                value: Pipewire.defaultAudioSink?.audio.volume * 100 ?? 0
                onMoved: newValue => {
                    if (Pipewire.defaultAudioSink?.audio) {
                        Pipewire.defaultAudioSink.audio.volume = newValue / 100;
                    }
                }
                from: 0
                to: 100
            }
            Text {
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 15
                Layout.maximumWidth: 20
                text: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100) + "%"
                color: Config.colors.text
            }
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.toggle()
        hoverEnabled: true
    }
}
