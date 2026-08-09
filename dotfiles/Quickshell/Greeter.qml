import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Greetd
import QtQuick
import QtQuick.Controls

ShellRoot {
  PanelWindow {
    anchors { top: true; bottom: true; left: true; right: true }
    color: "black"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    Column {
      anchors.centerIn: parent
      spacing: 12
      Text {
        text: "Login"
        color: "white"
        font.pixelSize: 24
      }

      TextField {
        id: usernameField
        placeholderText: "username"
        onAccepted: passwordField.forceActiveFocus()
      }

      TextField {
        id: passwordField
        placeholderText: "password"
        echoMode: TextInput.Password
        onAccepted: {
          statusText.text = ""
          Greetd.createSession(usernameField.text)
        }
      }
      Button {
        text: "Login"
        onClicked: {
          statusText.text = ""
          Greetd.createSession(usernameField.text)
        }
      }

      Text {
        id: statusText
        color: "red"
      }
    }

    Connections {
      target: Greetd

      function onAuthMessage(message, error, responseRequired, echoResponse) {
        if (responseRequired) {
          Greetd.respond(passwordField.text)
        } else if (Greetd.state === GreetdState.ReadyToLaunch) {
          Greetd.launch(["uwsm", "start", "hyprland-uwsm.desktop"])
        }
      }

      function onAuthFailure(msg) {
        statusText.text = msg || "Login failed"
        passwordField.text = ""
      }

      function onStateChanged() {
        if (Greetd.state === GreetdState.ReadyToLaunch) {
          Greetd.launch(["uwsm", "start", "hyprland-uwsm.desktop"])
        }
      }
    }
  }
}
