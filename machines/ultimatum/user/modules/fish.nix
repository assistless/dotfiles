{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
    };
    shellAbbrs = {
      config = {
        expansion = "$(fzf --walker-root=/home/demi/Configuration)";
        position = "anywhere";
      };
      configpath = {
        expansion = "/home/demi/Configuration";
      };
    };
  };
  home.shell.enableFishIntegration = true;
}
