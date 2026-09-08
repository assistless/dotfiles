-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function ()
  hl.exec_cmd("quickshell --daemonize")
  hl.exec_cmd("sleep 0.5 && quickshell ipc call lock lock")
  hl.exec_cmd("kdeconnect-indicator")
  hl.exec_cmd("flatpak run com.discordapp.Discord")
end)
