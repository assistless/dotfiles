{ config, pkgs, ... }:

{
  # NixOS
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
      };

      sansSerif = {
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
      };

      monospace = {
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 10;
        terminal = 11;
        desktop = 10;
        popups = 10;
      };
    };
    targets = {};
  };

  # Home Manager
  home-manager.users.demi = {
    stylix = {
      targets = { 
      	firefox = {
          enable = true;
          profileNames = [ "default" ];
        };
      };
    };
  };
}
