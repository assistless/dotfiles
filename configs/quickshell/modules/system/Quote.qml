import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Effects
import Quickshell.Io

import "../core"
PanelWindow {
    id: wallpaperPanel
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors { left: true; right: true; top: true; bottom: true }
    color: "transparent"

    FileView {
        id: quoteFile
        path: Qt.resolvedUrl(Quickshell.shellPath("quotes.json"))
        watchChanges: true

        onLoaded: randomizeQuote()
        onFileChanged: {
            this.reload();
            randomizeQuote();
        }
    }

    property var quotes: {
        try {
            if (quoteFile.text() !== "") {
                var parsed = JSON.parse(quoteFile.text());
                return parsed.quotes || [];
            }
        } catch (e) {
            console.error("JSON Parse Error:", e);
        }
        return [];
    }

    property string currentQuoteText: "Loading..."
    property string currentAuthor: ""

    function randomizeQuote() {
        if (quotes.length > 0) {
            var index = Math.floor(Math.random() * quotes.length);
            var selected = quotes[index];

            quoteContainer.opacity = 0;
            quoteChangeTimer.newText = selected.text;
            quoteChangeTimer.newAuthor = selected.author;
            quoteChangeTimer.start();
        }
    }

    Timer {
        id: quoteChangeTimer
        interval: 300
        property string newText: ""
        property string newAuthor: ""
        onTriggered: {
            currentQuoteText = newText;
            currentAuthor = newAuthor;
            quoteContainer.opacity = 1;
        }
    }

    // Optional IPC to manually refresh quotes
    IpcHandler {
        target: "quotes"
        function randomize(): string {
            randomizeQuote();
            return "Quote randomized.";
        }
    }
    // --- Quote Box UI ---
    Rectangle {
        id: quoteContainer
        anchors {
            bottom: parent.bottom
            right: parent.right
            bottomMargin: 50
            rightMargin: 25
        }
        radius: Config.data.bar.radius
        color: Qt.alpha(Theme.base, 0.78)
        width: 430
        height: quoteText.implicitHeight + 35
        border.color: Theme.accent
        border.width: 1

        Behavior on opacity { NumberAnimation { duration: 300 } }

        Text {
            id: quoteText
            text: `"${wallpaperPanel.currentQuoteText}"\n— ${wallpaperPanel.currentAuthor}`
            wrapMode: Text.WordWrap
            width: parent.width - 30
            color: Theme.text
            font.pixelSize: 12
            horizontalAlignment: Text.AlignLeft
            anchors.centerIn: parent
        }
    }
    Rectangle {
        anchors {
            bottom: quoteContainer.bottom
            right: quoteContainer.right
            bottomMargin: 5
            rightMargin: 5
        }
        width: 20
        height: 20
        radius: Config.data.bar.radius
        color: Theme.base
        border {
            width:1
            color: Theme.accent
        }
        Text {
            anchors.centerIn: parent
            text: ""
            font.pixelSize: 12
            color: Theme.accent
        }
        MouseArea {
            anchors.fill: parent
            onClicked: randomizeQuote()
        }
    }
    Component.onCompleted: randomizeQuote()
}
