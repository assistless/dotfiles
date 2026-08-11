{ config, pkgs, ... }:

let
  myCustomFont = pkgs.callPackage ../../../modules/hitmarker-fonts.nix { inherit pkgs; };
in
{
  stylix.fonts = {
    sansSerif = {
      package = myCustomFont;
      name = "Hitmarker Text VF";
    };
    serif = {
      package = myCustomFont;
      name = "Hitmarker Text VF";
    };
  };
}
