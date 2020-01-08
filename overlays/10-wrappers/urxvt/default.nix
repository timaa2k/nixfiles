{ pkgs, colors, fonts }:
let
  urxvt-config = import ./urxvt-conf.nix {
    inherit colors fonts;
  };
  urxvt-config-file = pkgs.writeTextFile {
    name = "urxvt-xresources";
    text = urxvt-config;
  };
in
pkgs.stdenv.mkDerivation {
  name = "urxvtWrapper";
  buildInputs = [ pkgs.makeWrapper ];
  phases = [ "buildPhase" ];
  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper "${pkgs.rxvt_unicode}/bin/urxvt" $out/bin/urxvt --set XENVIRONMENT ${urxvt-config-file}
  '';
}
