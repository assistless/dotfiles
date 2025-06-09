if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end
if status --is-login
    # Check if WAYLAND_DISPLAY is not set (i.e., not already in a Wayland session)
    # and if the current TTY is /dev/tty1 (or your preferred TTY)
    if test -z "$WAYLAND_DISPLAY"
        if test (tty) = /dev/tty1
            # Replace the current fish shell with Hyprland
            exec Hyprland
        end
    end
end
# Created by `pipx` on 2025-05-26 11:05:43
set PATH $PATH /home/assistless/.local/bin
