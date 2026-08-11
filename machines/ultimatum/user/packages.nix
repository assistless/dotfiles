{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.kate
    hyprlauncher
    fzf
    kdePackages.qtdeclarative
    nil
    grim
    slurp
    jq
    hyprshot
    wl-clipboard
    satty
    libnotify
  ]; 
}
