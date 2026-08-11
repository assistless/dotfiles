{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "hitmarker-fonts";
  version = "1.0";
  src = ../HitmarkerFonts; # Directory containing .ttf or .otf files

  installPhase = ''
    install -Dm644 *.ttf -t $out/share/fonts/truetype/
  '';
}
