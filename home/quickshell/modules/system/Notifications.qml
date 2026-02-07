import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick

NotificationServer {
            id: notifServer
            keepOnReload: false
            actionsSupported: true
            bodyHyperlinksSupported: true
            bodyImagesSupported: true
            bodyMarkupSupported: true
            imageSupported: true
            persistenceSupported: true

            onNotification: notif => {
                notif.tracked = true
            }
        }
