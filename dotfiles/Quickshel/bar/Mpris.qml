import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules
import "../config.js" as Config
import qs.services

Rectangle {
    id: root
    implicitHeight: 20
    implicitWidth: 150

    property var player: {
        const players = Mpris.players.values;
        if (players.length === 0)
            return null;
        if (Globals.currentPlayer >= 0 && Globals.currentPlayer < players.length)
            return players[Globals.currentPlayer];
        const playing = players.find(p => p.playbackState === MprisPlaybackState.Playing);
        const chosen = playing ?? players[0];
        const chosenIndex = players.indexOf(chosen);
        Globals.currentPlayer = chosenIndex;   // persist the auto-pick
        return chosen;
    }

    function selectPlayer(index) {
        Globals.currentPlayer = index;
    }
    Connections {
        target: root.player
        function onLoopStateChanged() {
            if (root.player) {
                root.player.positionChanged();
            }
        }
    }

    function formatTime(seconds) {
        if (!seconds || seconds < 0)
            return "0:00";
        const totalSeconds = Math.floor(seconds);
        const minutes = Math.floor(totalSeconds / 60);
        const secs = totalSeconds % 60;
        return minutes + ":" + (secs < 10 ? "0" : "") + secs;
    }

    color: mpris.visible ? Config.colors.accentDark : mouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : mouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bgLight, 1)
    radius: 9
    RowLayout {
        id: status
        anchors.fill: parent

        Text {
            text: ""
            color: Config.colors.text
            font.pixelSize: 12
            Layout.leftMargin: 6
            Layout.topMargin: -1
        }
        OverflowText {
            text: root.player ? root.player.trackTitle : "Nothing playing"
            color: Config.colors.text
            Layout.fillWidth: true
            Layout.rightMargin: Mpris.players.values.length > 1 ? 0 : 5
            Layout.topMargin: -1
        }
        Text {
            text: "+" + (Mpris.players.values.length - 1)
            visible: Mpris.players.values.length - 1 > 0
            color: Config.colors.text
            Layout.rightMargin: 5
            Layout.topMargin: -1
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            mpris.visible = !mpris.visible;
        }
        hoverEnabled: true
    }

    PanelWindow {
        id: mpris
        exclusiveZone: 0
        anchors {
            top: true
            left: true
        }
        visible: false
        implicitHeight: 210
        implicitWidth: 500
        color: "transparent"
        BackgroundEffect.blurRegion: Region {
            item: mpris.contentItem
        }
        Rectangle {
            anchors.fill: parent
            color: Qt.alpha(Config.colors.bg, 1)
            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 15
                SongInfo {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 10
                    layoutMode: "full"
                    artSize: 150
                    reversed: false
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 10
                    spacing: 5
                    Dropdown {
                        Layout.preferredWidth: 150
                        direction: "up"
                        model: Mpris.players.values
                        currentIndex: Globals.currentPlayer
                        textRole: player => player.identity ?? "Unknown"
                        placeholder: "No player"
                        onSelected: index => root.selectPlayer(index)
                    }
                    Rectangle {
                        color: Config.colors.bgLight
                        Layout.preferredHeight: 28
                        Layout.preferredWidth: 28
                        radius: 20
                        Text {
                            text: ""
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -1
                            color: root.player?.canQuit ? Config.colors.textMuted : Config.colors.text
                        }
                        MouseArea {
                            anchors.fill: parent
                            enabled: root.player?.canQuit ?? false
                            onClicked: root.player.quit()
                        }
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: ""
                        color: Config.colors.text
                        font.pixelSize: 24
                    }
                    Slider {
                        Layout.preferredWidth: 100
                        from: 0
                        to: 1
                        value: root.player?.volume ?? 0
                        onMoved: newValue => {
                            if (root.player) {
                                root.player.volume = newValue;
                            }
                        }
                        visible: root.player
                    }
                }
            }
        }
    }
}
