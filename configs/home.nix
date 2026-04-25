{ config, pkgs, inputs, lib, self, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  system = "x86_64-linux";
in
{
  imports = [
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
    kdePackages.ark
    nwg-look
    kdePackages.kate
    unzip
    python3
    nodejs
    kdePackages.qtdeclarative
    pnpm
    vscode-fhs
    godot
    blender
    xwayland-satellite
    inputs.awww.packages.${system}.awww
    chromium
    kdePackages.konsole
    nil
    _86Box
    javaPackages.compiler.temurin-bin.jre-21
    pavucontrol
    android-file-transfer
    brightnessctl
    spotdl
    llvmPackages_20.clang-tools
    yt-dlp
    fastfetch
    gnome-disk-utility
    uv
    kdePackages.systemsettings
    kdePackages.plasma-workspace
    kdePackages.knewstuff
    kdePackages.qqc2-breeze-style
    kdePackages.qtmultimedia
    python314Packages.tkinter
    tor-browser
    unrar
    ffmpeg
    wmenu
    adw-gtk3
  ];
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.kitty.enable = true;
  programs.mpv.enable = true;
  services.copyq.enable = true;
  programs.nushell.enable = true;
  services.polkit-gnome.enable = true;
  services.xembed-sni-proxy.enable = true;
  services.blueman-applet.enable = true;
  services.playerctld.enable = true;
  programs.btop.enable = true;
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "default";
      extensions.force = true;
    };
  };
  programs.wlogout.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuildNixOS = "bash ~/dotfiles/rebuild.sh";
    }; 
    functions = {
      fish_prompt = ''
        # Show nix-shell indicator
        if set -q IN_NIX_SHELL
          echo -n (set_color green)"[nix-shell] "(set_color normal)
        end
        # Your regular prompt
        echo -e -s (set_color yellow)$hostname(set_color green)@(set_color blue)(prompt_pwd --dir-length 0) 
	echo -e -n -s (set_color magenta)$USER(set_color magenta)'>'
      '';
      fish_right_prompt = ''
	echo -n -s (set_color red)"[$status]"
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
  gtk.enable = true;
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/demi/dotfiles/configs/niri/config.kdl";
    ".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/demi/dotfiles/configs/quickshell";
  };
  
  systemd.user.sessionVariables = config.home.sessionVariables;

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

