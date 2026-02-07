{ config, lib, pkgs, inputs, ... }:

{
  # Common settings for both machines
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users.users.demi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "uinput" ];
  };

  services.openssh.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  networking = {
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = false;
        };
      };
    };
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    networks."20-wireless" = {
      matchConfig.Name = "wl*";
      networkConfig = {
        DHCP = "yes";
        DNSDefaultRoute = true;
      };
      dhcpV4Config = {
        RouteMetric = 100;
      };
    };
    networks."10-wired" = {
      matchConfig.Name = "en*";
      networkConfig = {
        DHCP = "yes";
      };
      dhcpV4Config = {
        RouteMetric = 10;
      };
    };
  };

  fonts = {
    enableDefaultPackages = lib.mkForce false;
    packages = with pkgs; [
      maple-mono.NF-CN
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
    ];
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
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wget
    lynx
    gcc
    libgcc
    gnumake
  ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://hyprland.cachix.org"
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
