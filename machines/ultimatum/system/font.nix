{ pkgs, ... }:
let
  hitmarker-fonts = pkgs.callPackage ../../../modules/hitmarker-fonts.nix { inherit pkgs; };
in
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
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
        serif = [ "Hitmarker Text VF" ];
        sansSerif = [ "Hitmarker Text VF" ];
        monospace = [ "Fira Code" ];
      };
    };
  };
}
