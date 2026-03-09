import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../core"


ColumnLayout {

    id: appsRoot
    anchors.fill: parent
    anchors.margins: 8
    spacing: 6

    signal closeRequested()
    function focusSearch() {
        searchField.forceActiveFocus()
        searchField.text = ""
        selectedIndex = 0
        hoverReady = false
        hoverDelay.restart()
    }
    property bool showMostUsed: true
    property int selectedIndex: 0
    property bool hoverReady: false

    Timer {
        id: hoverDelay
        interval: 400
        repeat: false
        onTriggered: appsRoot.hoverReady = true
    }

    function getUsage() { return AppUsage.get() }
    function usageKey(app) { return app.name }

    function launchApp(app) {
        AppUsage.record(usageKey(app))
        app.execute()
        appsRoot.closeRequested()
    }

    function fuzzyScore(name, query) {
        if (query === "") return 1
            const n = name.toLowerCase()
            const q = query.toLowerCase()

            if (n.startsWith(q)) return 1000 + (100 - n.length)

                let score = 0
                let ni = 0; let qi = 0
                let consecutive = 0; let lastMatch = -1

                while (ni < n.length && qi < q.length) {
                    if (n[ni] === q[qi]) {
                        const wordStart = ni === 0 || n[ni-1] === ' ' || n[ni-1] === '-'
                        consecutive = (lastMatch === ni - 1) ? consecutive + 1 : 0
                        score += 10 + (wordStart ? 20 : 0) + (consecutive * 5)
                        lastMatch = ni
                        qi++
                    }
                    ni++
                }
                return qi === q.length ? score : 0
    }

    // Search bar
    Rectangle {
        Layout.fillWidth: true
        height: 36
        radius: 6
        color: Theme.surface0
        clip: true
        border {
            width: 1
            color: Theme.accent
        }
        TextInput {
            id: searchField
            anchors.fill: parent
            anchors.margins: 8
            color: Theme.subtext0
            font.pixelSize: 14
            onTextChanged: {
                appsRoot.selectedIndex = 0
                tt.visible = false
            }
            Keys.onEscapePressed: appsRoot.closeRequested()
            Text {
                id: tt
                text: "Search..."
                color: Theme.subtext0
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
                font.italic: true
            }
            Keys.onReturnPressed: {
                if (appModel.values.length > 0)
                    launchApp(appModel.values[appsRoot.selectedIndex])
            }
            Keys.onDownPressed: {
                if (appsRoot.selectedIndex < appModel.values.length - 1) {
                    appsRoot.selectedIndex++
                    appList.positionViewAtIndex(appsRoot.selectedIndex, ListView.Contain)
                }
            }
            Keys.onUpPressed: {
                if (appsRoot.selectedIndex > 0) {
                    appsRoot.selectedIndex--
                    appList.positionViewAtIndex(appsRoot.selectedIndex, ListView.Contain)
                }
            }
        }
    }

    // Most used strip
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 4
        visible: searchField.text.length === 0 && appsRoot.showMostUsed
        Rectangle {
            Layout.leftMargin: 2
            Layout.fillWidth: true
            height: 12
            color: "transparent"
            Text {
                text: "Most Used"
                color: Theme.subtext0
                font.pixelSize: 11
            }
            Rectangle {
                anchors.right: parent.right
                implicitWidth: 50
                implicitHeight: 20
                Layout.rightMargin: 2
                radius: Config.data.bar.radius
                color: Theme.surface0
                Text {
                    text: "Clear"
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: AppUsage.clear()
                }
            }
        }
        ListView {
            Layout.fillWidth: true
            height: 72
            orientation: ListView.Horizontal
            clip: true
            spacing: 6

            model: ScriptModel {
                values: {
                    const _dep = AppUsage.revision
                    const usage = getUsage()
                    const withUsage = DesktopEntries.applications.values
                    .filter(a => (usage[usageKey(a)] || 0) > 0)
                    if (withUsage.length === 0) return []
                        return withUsage
                        .slice()
                        .sort((a, b) => (usage[usageKey(b)] || 0) - (usage[usageKey(a)] || 0))
                        .slice(0, 8)
                }
            }

            delegate: Rectangle {
                required property var modelData
                width: 60
                height: 72
                radius: 6
                color: muHover.containsMouse ? Theme.surface2 : "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 3

                    IconImage {
                        implicitSize: 28
                        Layout.alignment: Qt.AlignHCenter
                        source: modelData.icon ? Quickshell.iconPath(modelData.icon) : ""
                    }

                    Text {
                        Layout.fillWidth: true
                        text: modelData.name
                        color: Theme.text
                        font.pixelSize: 9
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                MouseArea {
                    id: muHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: launchApp(modelData)
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.surface1
        }
    }

    // App list
    ListView {
        id: appList
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 2

        model: ScriptModel {
            id: appModel
            values: {
                const q = searchField.text
                const _dep = AppUsage.revision
                const usage = getUsage()

                return DesktopEntries.applications.values
                .map(app => ({
                    app,
                    score: fuzzyScore(app.name, q) + (usage[usageKey(app)] || 0) * 2
                }))
                .filter(e => e.score > 0)
                .sort((a, b) => {
                    const diff = b.score - a.score
                    if (diff !== 0) return diff
                        return a.app.name.localeCompare(b.app.name)
                })
                .map(e => e.app)
            }
        }

        delegate: Rectangle {
            required property var modelData
            required property int index
            width: appList.width
            height: 44
            radius: 6
            color: (appsRoot.selectedIndex === index || mouseArea.containsMouse)
            ? Theme.surface2
            : "transparent"

            Rectangle {
                visible: appsRoot.selectedIndex === index
                x: 0; anchors.verticalCenter: parent.verticalCenter
                width: 3; height: 24; radius: 2
                color: Theme.accent
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 8
                anchors.topMargin: 8
                anchors.bottomMargin: 8
                spacing: 10

                IconImage {
                    implicitSize: 28
                    source: modelData.icon ? Quickshell.iconPath(modelData.icon) : ""
                }

                Text {
                    Layout.fillWidth: true
                    text: modelData.name
                    color: Theme.text
                    font.pixelSize: 14
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: if (appsRoot.hoverReady) appsRoot.selectedIndex = index
                onClicked: launchApp(modelData)
            }
        }
    }
}
