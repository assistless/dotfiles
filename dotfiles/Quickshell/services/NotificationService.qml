pragma Singleton
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    property alias server: server
    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: notification => {
            notification.tracked = true;
        }
    }
}
