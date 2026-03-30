pragma Singleton
import Quickshell
import Quickshell.Io
Singleton {
    id: config
    property alias data: adapter

    property bool isDarkTheme: adapter.theme.mode === "dark" ? true : adapter.theme.mode === "light" ? false : true

    function save() {
        configFile.writeAdapter()
    }
    property string accentColor: Theme[adapter.theme.accent] ?? Theme.accent
    FileView {
        id: configFile
        path: Quickshell.shellPath("config.json")
        watchChanges: true
        blockLoading: true

        onFileChanged: {
            console.log("Config changed, reloading...");
            this.reload();
        }

        JsonAdapter {
            id: adapter

            property JsonObject bar: JsonObject {
                property int size: 30
                property int radius: 15
                property int edges: 5
            }

            property JsonObject theme: JsonObject {
                property string mode: "dark"
                property string accent: "accent"
            }

            property JsonObject wallpaper: JsonObject {
                property string path: ""
            }
        }
    }
}
