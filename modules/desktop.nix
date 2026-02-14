{ config, lib, pkgs, inputs, ... }:
let
  system = "x86_64-linux";
in
{

  services.displayManager.gdm.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
}
