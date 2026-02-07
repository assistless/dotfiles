//@ pragma UseQApplication
//@ pragma IconTheme Papirus
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Niri
import "./modules/bar/"
import "./modules/system/"
import "./modules/core/"

ShellRoot{
    id: root

    LazyLoader{ active: true; component: Bar{} }
    LazyLoader{ active: true; component: Quote{} }
    LazyLoader{ active: true; component: Volume{} }
    LazyLoader{ active: true; component: Notifications{} }

    Item {
        Niri {
            id: niri
            Component.onCompleted: connect()

            onConnected: console.log("Connected to niri")
            onErrorOccurred: function(error) {
                console.error("Error:", error)
            }
        }
    }
}

