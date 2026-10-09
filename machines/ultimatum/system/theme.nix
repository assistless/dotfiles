{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = {
      scheme = "custom";
      author = "custom";
      base00 = "1a1a1a";
      base01 = "262626";
      base02 = "0d0d0d";
      base03 = "4d4d4d";
      base04 = "999999";
      base05 = "ffffff";
      base06 = "e6e6e6";
      base07 = "ffffff";
      base08 = "d65c5c";
      base09 = "d6995c";
      base0A = "d6d65c";
      base0B = "5cd65c";
      base0C = "5cd6d6";
      base0D = "6633cc";
      base0E = "7547d1";
      base0F = "d67a5c";
    };
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.hitmarker-fonts;
        name = "Hitmarker Text VF";
      };

      sansSerif = {
        package = pkgs.hitmarker-fonts;
        name = "Hitmarker Text VF";
      };

      monospace = {
        package = pkgs.cascadia-code;
        name = "Cascadia Code";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes.applications = 10;
      sizes.terminal = 11;
    };
    icons = {
      enable = true;
      dark = "Papirus";
      light = "Papirus";
    };
  };
}
