{ ... }:
{
  stylix = {
    targets.gtk.extraCss = ''
      * { border-radius: 0 !important; }
    '';
    targets.firefox.profileNames = [ "default" ];
  };
}