{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = {
      scheme = "custom";
      author = "custom";
      base00 = "0d0d0d";  # bgDark 
      base01 = "1a1a1a";  # bg      
      base02 = "262626";  # bgLight 
      base03 = "4d4d4d";  # border  
      base04 = "b3b3b3";  # textMuted 
      base05 = "e6e6e6";  # text    
      base06 = "e6e6e6";
      base07 = "e6e6e6";  
      base08 = "b12525";  # red
      base09 = "b16b25";  # orange
      base0A = "b1b125";  # yellow
      base0B = "25b154";  # green
      base0C = "259ab1";  # cyan
      base0D = "6b25b1";  # purple 
      base0E = "2554b1";  # blue
      base0F = "b12582";  # magenta
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
