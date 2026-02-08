{ config, lib, pkgs, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/shared.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "lenovo";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    configurationLimit = 5;
  };

  swapDevices = [
    { device = "/dev/sda2"; }  
  ];

  system.stateVersion = "25.11";
}
