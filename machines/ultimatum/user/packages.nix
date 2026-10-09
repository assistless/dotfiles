{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    nil
    grim
    slurp
    jq
    hyprshot
    wl-clipboard
    libnotify
    vscodium-fhs
    sm64coopdx
    r2modman
    papirus-folders
  ]; 
}
