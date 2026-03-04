{ config, pkgs, inputs, lib, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  system = "x86_64-linux";
in
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "demi";
  home.homeDirectory = "/home/demi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    wl-clipboard 
    papirus-icon-theme
    kdePackages.ark
    nwg-look
    kdePackages.kate
    mpv
    ripgrep
    fd
    unzip
    python3
    nodejs
    kdePackages.qtdeclarative
    pnpm
    nautilus
    antimicrox
    vscodium-fhs
    godot
    blender
    xwayland-satellite
    inputs.awww.packages.${system}.awww
    chromium
    kdePackages.konsole
    gnome-software
    nil
    virt-manager
    virt-viewer
    _86Box
    dosbox-staging
    quickemu
    looking-glass-client
    javaPackages.compiler.temurin-bin.jre-21
    pavucontrol
    android-file-transfer
    brightnessctl
    spotdl
    llvmPackages_20.clang-tools
  ];

  services.xembed-sni-proxy.enable = true;
  services.blueman-applet.enable = true;
  services.polkit-gnome.enable = true;
  services.playerctld.enable = true;
  programs.bottom.enable = true;
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
    theme = lib.mkForce (spicePkgs.themes.catppuccin // {
    appendName = true;
    additionalCss = ''
      *
      ::before
      ::after {
        font-family: "Maple Mono NF CN", sans-serif !important;
        font-weight: 400; /* Regular */
      }
      body,
      html {
        font-family: "Maple Mono NF CN", sans-serif !important;
        font-weight: 400; /* Regular */
      }

      .main-entityHeader-title,
      .main-entityHeader-titleText {
        font-family: "Maple Mono NF CN", sans-serif !  important;
        font-weight: 700; /* Bold */
      }

      .main-trackList-trackName,
      .main-trackList-rowTitle {
        font-family: "Maple Mono NF CN", sans-serif !important;
        font-weight: 400; /* Regular */
      }

      button,
      .main-buttons-button,
      .main-playButton-PlayButton {
        font-family: "Maple Mono NF CN", sans-serif !important;
        font-weight: 800; /* ExtraBold */
      }

      h1, h2, h3,
      .main-shelf-header {
        font-family: "Maple Mono NF CN", sans-serif !  important;
        font-weight: 900; /* Ultra */
      }
      '';
    });
    colorScheme = lib.mkForce "mocha";
  };

  wayland.windowManager.hyprland.systemd.enable = true;
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    extraConfig = "shell fish";
  };
  programs.fuzzel.enable = true;
  programs.firefox.enable = true;
  services.hyprpolkitagent.enable = true;
  programs.wlogout.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuildNixOS = "bash ~/dotfiles/rebuild.sh";
      editConfig = "$EDITOR /etc/nixos/";
    }; 
    functions = {
      fish_prompt = ''
        # Show nix-shell indicator
        if set -q IN_NIX_SHELL
          echo -n (set_color blue)"[nix-shell] "(set_color normal)
        end
      
        # Your regular prompt
        echo -n (set_color cyan)(prompt_pwd)(set_color normal)' > '
        '';
      };
    };
  programs.quickshell = {
    enable = true;
    package = inputs.qml-niri.packages.${system}.quickshell;
  };

  nixpkgs.config.allowUnfree = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/niri/config.kdl".source = ./niri.kdl;
  };
  
  systemd.user.sessionVariables = config.home.sessionVariables // {
    QT_STYLE_OVERRIDE = lib.mkForce "Fusion";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/demi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "kate";
    TZ = "Asia/Ho_Chi_Minh";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

