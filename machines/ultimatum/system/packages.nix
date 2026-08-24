{ pkgs, ... }:
{
  # packages
  environment.systemPackages = with pkgs; [
    quickshell
    sway
    git
    kdePackages.ark
    kdePackages.qtdeclarative
    sshfs
  ];
}
