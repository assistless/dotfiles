{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      cascadia-code
      mplus-outline-fonts.githubRelease
      nerd-fonts.symbols-only
      hitmarker-fonts
    ];
    fontconfig = {
      antialias = true;
      includeUserConf = false;
      useEmbeddedBitmaps = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
      defaultFonts = {
        serif = [ "Hitmarker Text VF" "Symbols Nerd Font" ];
        sansSerif = [ "Hitmarker Text VF" "Symbols Nerd Font" ];
        monospace = [ "Cascadia Code" "Symbols Nerd Font" ];
      };
    };
  };
}
