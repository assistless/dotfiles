pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: config
    property alias data: adapter // Use alias for easier access

    function save() {
        configFile.writeAdapter()
    }

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
            }
            // Add this block:
            property JsonObject theme: JsonObject {
                property bool dark: true
            }
            property JsonObject wallpaper: JsonObject {
                property string path: ""
            }
        }
    }
}
