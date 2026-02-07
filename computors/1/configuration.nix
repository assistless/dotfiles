{ config, lib, pkgs, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/shared.nix
    ../../modules/gaming.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "dell";

  # EFI boot
  boot.loader.systemd-boot = {
    enable = true;
     configurationLimit = 5;
  }
  boot.loader.efi.canTouchEfiVariables = true;

  # Btrfs with compression
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/windows" = {
      device = "/dev/sda3";
      fsType = "ntfs-3g";
      options = [
        "rw"
        "uid=1000"
        "gid=100"
        "dmask=022"
        "fmask=133"
        "windows_names"
      ];
    };
  };

  # Swap file
  swapDevices = [{
    device = "/swap/swapfile";
    size = 8*1024;
  }];

  services.btrfs.autoScrub.enable = true;

  system.stateVersion = "25.11";
}
