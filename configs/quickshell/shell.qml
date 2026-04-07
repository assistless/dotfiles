//@ pragma UseQApplication
//@ pragma IconTheme Papirus
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Niri
import "./bar/"
import "./system/"
import "./core/"

ShellRoot{
    id: root
    Bar{}
    Wallpaper{}
    Volume{}
    Notifications{}
    Launcher{}
    Runner{}
    Item {
        Niri {
            id: niri

            Component.onCompleted: connect()

            onConnected: console.info("Connected to niri")
            onErrorOccurred: function(error) {
                console.error("Niri error:", error)
            }
        }
    }
    PersistentProperties {
        id: appUsageStorage
        property string usageJson: "{}"
    }
}
