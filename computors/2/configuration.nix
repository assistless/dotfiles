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

  # BIOS boot (adjust device to your actual disk)
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    configurationLimit = 5;
  };

  # ext4 filesystems (no special options needed)
  # hardware-configuration.nix will have the actual mount points

  # 16GB swap partition
  swapDevices = [
    { device = "/dev/sda2"; }  # Adjust to your actual swap partition
  ];

  system.stateVersion = "25.11";
}
