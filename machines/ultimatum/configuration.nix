# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  # swap
  swapDevices = [{
    device = "/swap/swapfile";
    size = 8*1024; # Creates an 8GB swap file
  }];

  # flatpak
  services.flatpak.enable = true;

  # polkit
  security.polkit.enable = true;
  security.polkit.enablePkexecWrapper = true;

  # flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # import
  imports = lib.fileset.toList (lib.fileset.difference (lib.fileset.fileFilter (f: f.hasExt "nix") ./system) (./configuration.nix));

  # boot
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport= true;
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  # hostname
  networking.hostName = "ultimatum";

  # network
  networking.networkmanager.enable = true;

  # time zone
  time.timeZone = "Asia/Ho_Chi_Minh";

  # sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # touchpad
  services.libinput.enable = true;

  # user
  users.users.demi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    # packages = with pkgs; [];
  };

  # packages
  environment.systemPackages = with pkgs; [
    quickshell
    sway
    git
  ];

  # misc
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # ssh
  services.openssh.enable = true;

  # firewall
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

  system.stateVersion = "26.05"; # dont change

}

