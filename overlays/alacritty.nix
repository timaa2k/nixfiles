self: super:

with super;

let
  execPath = if stdenv.isDarwin then "Applications/Alacritty.app/Contents/MacOS" else "bin";
  configFile = writeTextFile {
    name = "alacritty.yml";
    text = builtins.readFile ./dotfiles/.alacritty.yml;
  };
in
{
  alacritty = stdenv.mkDerivation {
    name = "alacrittyConf";
    buildInputs = [ makeWrapper ];
    propagatedBuildInputs = [ alacritty ];
    phases = [ "buildPhase" ];
    buildCommand = ''
      mkdir -p $out/bin
      makeWrapper ${alacritty}/${execPath}/alacritty $out/bin/alacritty --add-flags "--config-file ${configFile}"
    '';
  };
}
