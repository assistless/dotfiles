// modules/core/SystemService.qml
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick 2.15

Singleton {
    id: root
    function powerOff() { Quickshell.execDetached({command: ["systemctl", "poweroff"]})}
    function restart()  { Quickshell.execDetached({command: ["systemctl", "reboot"]})}
    function suspend()  { Quickshell.execDetached({command: ["systemctl", "suspend"]})}
    function lock()     { Quickshell.execDetached({command: ["loginctl", "lock-session"]})}
    function logout()   { Quickshell.execDetached({command: ["niri", "msg", "action", "quit",]})}
}
