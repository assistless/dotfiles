{ config, lib, pkgs, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/gaming.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "nixos";

  # EFI boot
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Btrfs with compression
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  # Swap file
  swapDevices = [{
    device = "/swap/swapfile";
    size = 8*1024;
  }];

  services.btrfs.autoScrub.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
