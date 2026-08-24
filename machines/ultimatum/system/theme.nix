{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = {
      scheme = "custom";
      author = "custom";
      base00 = "1a1a1a";
      base01 = "333333";
      base02 = "4d4d4d";
      base03 = "4d4d4d";
      base04 = "bfbfbf";
      base05 = "f2f2f2";
      base06 = "f2f2f2";
      base07 = "f2f2f2";
      base08 = "b12525";
      base09 = "b16b25";
      base0A = "b1b125";
      base0B = "25b154";
      base0C = "259ab1";
      base0D = "6b25b1";
      base0E = "2554b1";
      base0F = "b12582";
    };
    stylix.polarity = "dark";
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
    };
    targets.gtk.extraCss = ''
      * { border-radius: 0 !important; }
    '';
  };
}
