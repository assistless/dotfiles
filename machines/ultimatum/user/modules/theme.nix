{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };
}
