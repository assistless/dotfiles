{ config, pkgs, lib, ...}:

{ 
  imports = lib.fileset.toList (lib.fileset.difference (lib.fileset.fileFilter (f: f.hasExt "nix") ./user) (./home.nix));
 
  home.username = "demi";
  home.homeDirectory = "/home/demi";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
