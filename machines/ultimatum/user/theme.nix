{ ... }:
{
  stylix = {
    enable = true;
    targets.gtk.extraCss = ''
      *:not(switch):not(.circular) {
        border-radius: 0 !important;
      }
    '';
    targets.firefox.profileNames = [ "default" ];
  };
}