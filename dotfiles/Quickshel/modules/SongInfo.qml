import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import qs.modules
import "../config.js" as Config
import qs.services

Rectangle {
    id: root
    color: "transparent"
    property int artSize: 150
    property string layoutMode: "full"   // "full" | "compact" | "vertical"
    property bool reversed: false        // false = left-first, true = right-first (horizontal layouts only)

    readonly property real currentPosition: {
        if (!player || !player.length || player.length <= 0)
            return 0;
        const position = player.position;
        const length = player.length;
        if (player.loopState === MprisLoopState.Track && position >= length)
            return position % length;
        return Math.min(position, length);
    }

    Timer {
        running: root.player !== null && root.player.playbackState === MprisPlaybackState.Playing
        interval: 1000
        repeat: true
        onTriggered: {
            if (root.player)
                root.player.positionChanged();
        }
    }

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

    function formatTime(seconds) {
        const totalSeconds = Math.floor(seconds);
        const minutes = Math.floor(totalSeconds / 60);
        const secs = totalSeconds % 60;
        return minutes + ":" + (secs < 10 ? "0" : "") + secs;
    }

    // ---- shared sub-pieces ----

    component AlbumArt: Rectangle {
        Layout.preferredWidth: root.artSize
        Layout.preferredHeight: root.artSize
        property int artSize: root.artSize
        clip: true
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: root.player?.trackArtUrl ?? ""
        }
    }

    component TitleArtist: ColumnLayout {
        OverflowText {
            text: root.player ? root.player.trackTitle : "Nothing playing"
            Layout.fillWidth: true
            horizontalAlignment: root.layoutMode === "vertical" ? Text.AlignHCenter : (root.reversed ? Text.AlignRight : Text.AlignLeft)
            size: 20
            title: true
            color: Config.colors.text
        }
        Text {
            text: root.player ? root.player.trackArtist : ""
            color: Config.colors.text
            visible: text != ""
            Layout.fillWidth: true
            horizontalAlignment: root.layoutMode === "vertical" ? Text.AlignHCenter : (root.reversed ? Text.AlignRight : Text.AlignLeft)
        }
    }

    component ProgressRow: ColumnLayout {
        Slider {
            Layout.fillWidth: true
            from: 0
            to: root.player?.length ?? 1
            value: root.currentPosition
            onMoved: newValue => {
                if (root.player?.canSeek)
                    root.player.position = newValue;
            }
        }
        Text {
            color: "white"
            text: root.formatTime(root.currentPosition) + " / " + root.formatTime(root.player?.length ?? 0)
        }
    }

    component Controls: RowLayout {
        spacing: 8
        Rectangle {
            color: (root.player?.loopState ?? MprisLoopState.None) !== MprisLoopState.None ? Config.colors.accentDark : loopMouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : loopMouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bgLight, 1)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 20
            Text {
                text: {
                    if (!root.player)
                        return "󰑗";
                    switch (root.player.loopState) {
                    case MprisLoopState.Track:
                        return "󰑘";
                    case MprisLoopState.Playlist:
                        return "󰑖";
                    default:
                        return "󰑗";
                    }
                }
                font.pixelSize: 20
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -1
                anchors.horizontalCenterOffset: root.player.loopState !== MprisLoopState.None ? 0.5 : 0
                color: (root.player?.loopState ?? MprisLoopState.None) !== MprisLoopState.None ? Config.colors.text : Config.colors.text
            }
            MouseArea {
                id: loopMouse
                anchors.fill: parent
                enabled: root.player?.canControl ?? false
                onClicked: {
                    const states = [MprisLoopState.None, MprisLoopState.Track, MprisLoopState.Playlist];
                    const currentIndex = states.indexOf(root.player.loopState);
                    root.player.loopState = states[(currentIndex + 1) % states.length];
                }
                hoverEnabled: true
            }
        }
        Rectangle {
            color: prevMouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : prevMouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bgLight, 1)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 20
            Text {
                text: ""
                font.pixelSize: 18
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -1
                color: root.player?.canGoPrevious ? Config.colors.text : Qt.alpha(Config.colors.text, 0.4)
            }
            MouseArea {
                id: prevMouse
                anchors.fill: parent
                enabled: root.player?.canGoPrevious ?? false
                onClicked: root.player.previous()
            }
        }

        Rectangle {
            color: playPauseMouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : playPauseMouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bgLight, 1)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 20
            Text {
                text: root.player?.playbackState === MprisPlaybackState.Playing ? "" : ""
                font.pixelSize: 18
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 1
                anchors.verticalCenterOffset: -1
                color: (root.player?.canPlay || root.player?.canPause) ? Config.colors.text : Qt.alpha(Config.colors.text, 0.4)
            }
            MouseArea {
                id: playPauseMouse
                anchors.fill: parent
                enabled: (root.player?.canPlay || root.player?.canPause) ?? false
                onClicked: root.player.togglePlaying()
            }
        }

        Rectangle {
            color: nextMouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : nextMouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bgLight, 1)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 20
            Text {
                text: ""
                font.pixelSize: 18
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -1
                color: root.player?.canGoNext ? Config.colors.text : Qt.alpha(Config.colors.text, 0.4)
            }
            MouseArea {
                id: nextMouse
                anchors.fill: parent
                enabled: root.player?.canGoNext ?? false
                onClicked: root.player.next()
            }
        }

        Rectangle {
            color: stopMouse.containsPress ? Qt.alpha(Config.colors.accentDark, 1) : stopMouse.containsMouse ? Qt.alpha(Config.colors.accent, 1) : Qt.alpha(Config.colors.bgLight, 1)
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 20
            Text {
                text: ""
                font.pixelSize: 18
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -1
                color: root.player?.canControl ? Config.colors.text : Qt.alpha(Config.colors.text, 0.4)
            }
            MouseArea {
                id: stopMouse
                anchors.fill: parent
                enabled: root.player?.canControl ?? false
                onClicked: root.player.stop()
            }
        }
    }

    // ---- layout switch ----

    Loader {
        anchors.fill: root
        sourceComponent: {
            if (root.layoutMode === "compact")
                return compactLayout;
            if (root.layoutMode === "vertical")
                return verticalLayout;
            return fullLayout;
        }
    }

    Component {
        id: fullLayout
        RowLayout {
            layoutDirection: root.reversed ? Qt.RightToLeft : Qt.LeftToRight
            spacing: 10
            AlbumArt {}
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                layoutDirection: Qt.LeftToRight
                TitleArtist {}
                ProgressRow {
                    Layout.fillWidth: true
                }
                Controls {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Component {
        id: compactLayout
        RowLayout {
            layoutDirection: root.reversed ? Qt.RightToLeft : Qt.LeftToRight
            spacing: 10
            AlbumArt {
                artSize: 32
            }
            ColumnLayout {
                TitleArtist {
                    Layout.fillWidth: true
                }
                Controls {
                    Layout.alignment: root.reversed ? Qt.AlignRight : Qt.AlignLeft
                }
            }
        }
    }

    Component {
        id: verticalLayout
        ColumnLayout {
            spacing: 8
            AlbumArt {
                Layout.alignment: Qt.AlignHCenter
            }
            TitleArtist {
                Layout.fillWidth: true
            }
            ProgressRow {
                Layout.fillWidth: true
            }
            Controls {
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
