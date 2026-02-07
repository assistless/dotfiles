{ config, lib, pkgs, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  boot.kernelModules = [ "uinput" ];
  boot.plymouth.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "ntsync.enable=1" ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 30;
  };

  hardware.uinput.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.upower.enable = true;
  services.libinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  users.groups.uinput = {};

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

  niri-flake.cache.enable = true;
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
}
