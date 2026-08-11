import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Greetd
import QtQuick

ShellRoot {
  FloatingWindow {
    id: win
    title: Time.fullDisplay
    color: "black"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Column {
      anchors.centerIn: parent
      spacing: 12

      Text {
        text: "Login"
        color: "white"
        font.pixelSize: 24
      }
      Text {
        text: "Username:"
        color: "white"
      }
      // ---------------- username field ----------------
      Rectangle {
        width: 220
        height: 36
        color: "black"
        border.color: "white"
        border.width: 1
        radius: 0

        TextInput {
          id: usernameField
          anchors.fill: parent
          anchors.leftMargin: 8
          anchors.rightMargin: 8
          verticalAlignment: TextInput.AlignVCenter
          color: "white"
          font.pixelSize: 14
          clip: true
          selectionColor: "white"
          selectedTextColor: "black"

          Keys.onReturnPressed: passwordField.forceActiveFocus()
          Keys.onEnterPressed: passwordField.forceActiveFocus()
        }
      }
      Text {
        text: "Password:"
        color: "white"
      }
      // ---------------- password field ----------------
      Rectangle {
        width: 220
        height: 36
        color: "black"
        border.color: "white"
        border.width: 1
        radius: 0

        TextInput {
          id: passwordField
          anchors.fill: parent
          anchors.leftMargin: 8
          anchors.rightMargin: 8
          verticalAlignment: TextInput.AlignVCenter
          color: "white"
          font.pixelSize: 14
          echoMode: TextInput.Password
          clip: true
          selectionColor: "white"
          selectedTextColor: "black"

          Keys.onReturnPressed: win.doLogin()
          Keys.onEnterPressed: win.doLogin()
        }
      }

      // ---------------- login button ----------------
      Rectangle {
        width: 220
        height: 36
        radius: 0
        color: loginArea.pressed ? "white" : (loginArea.containsMouse ? "#222222" : "black")
        border.color: "white"
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "Login"
          color: loginArea.pressed ? "black" : "white"
          font.pixelSize: 14
        }

        MouseArea {
          id: loginArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: win.doLogin()
        }
      }

      Text {
        id: statusText
        color: "white"
      }
    }

    function doLogin() {
      statusText.text = ""
      Greetd.createSession(usernameField.text)
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
