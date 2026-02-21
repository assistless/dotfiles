{ config, lib, pkgs, inputs, ... }:
let
  system = "x86_64-linux";
in
{

  services.displayManager.sddm.enable = true;
  services.xserver.enable = true;
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
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
}
