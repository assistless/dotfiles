{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr-140;
    profiles.default = {};
  };
}
