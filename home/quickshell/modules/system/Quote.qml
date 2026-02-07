import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Effects
import Quickshell.Io
import "../../assets"

PanelWindow {
    id: wallpaperPanel
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors { left: true; right: true; top: true; bottom: true }
    color: "transparent"

    // --- Quote File Watching ---
    FileView {
        id: quoteFile
        path: Qt.resolvedUrl(Quickshell.shellPath("quotes.json"))
        blockLoading: true
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
        radius: 10
        color: Qt.alpha(Theme.base, 0.78)
        width: 430
        height: quoteText.implicitHeight + 35
        border.color: Theme.mauve
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
        radius: 15
        color: Theme.base
        Text {
            anchors.centerIn: parent
            text: ""
            font.pixelSize: 12
            color: Theme.mauve
        }
        MouseArea {
            anchors.fill: parent
            onClicked: randomizeQuote()
        }
    }
    Component.onCompleted: randomizeQuote()
}
