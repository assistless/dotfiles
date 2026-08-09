{ config, pkgs, ... }:
{
  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/demi/Configuration/dotfiles/Hyprland/";
  };
  xdg.configFile."quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/demi/Configuration/dotfiles/Quickshell/";
  };
}
