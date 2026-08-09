{ pkgs, ... }:
{
  stylix.icons = {
    enable = true;
    package = pkgs.tela-icon-theme;
    light = "Tela";
    dark = "Tela dark";
  };
}
