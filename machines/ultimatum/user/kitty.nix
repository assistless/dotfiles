{ pkgs, ... }:
{
  programs.kitty= {
    enable = true;
    extraConfig = ''
      shell fish
    '';
  };
}
