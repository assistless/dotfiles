{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.kate
    hyprlauncher
    fzf
    nil
    grim
    slurp
    jq
    hyprshot
    wl-clipboard
    satty
    libnotify
    vscodium-fhs
    blender
    godot
    sm64coopdx
    r2modman
    papirus-folders
    gearlever
    eden
  ]; 
}
