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
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-qt
        fcitx5-bamboo
      ];
    };
  };

  fonts = {
    enableDefaultPackages = lib.mkForce false;
    packages = with pkgs; [ maple-mono.NF-CN noto-fonts-color-emoji noto-fonts-cjk-sans noto-fonts ];
    fontconfig = {
      antialias = true;
      includeUserConf = false;
      hinting = {
        enable = true;
        style = "full";
      };
      subpixel = {
        lcdfilter = "default";
        rgba = "none";
      };
      defaultFonts = let font = [ "Maple Mono NF CN" ];
        in { serif = font; sansSerif = font; monospace = font; };
    };
  };

  catppuccin = {
    enable = true;
    flavor = "latte";
    accent = "green";
  };

  programs.niri = {
    enable = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
}
