self: super:

let
  execPath = if self.stdenv.isDarwin then "Applications/Alacritty.app/Contents/MacOS" else "bin";
  configFile = self.writeTextFile {
    name = "alacritty.yml";
    text = builtins.readFile ./alacritty.yml;
  };
in
{
  alacritty = self.stdenv.mkDerivation {
    name = "alacrittyConf";
    buildInputs = [ self.makeWrapper ];
    propagatedBuildInputs = [ super.alacritty ];
    phases = [ "buildPhase" ];
    buildCommand = ''
      mkdir -p $out/bin
      makeWrapper ${super.alacritty}/${execPath}/alacritty $out/bin/alacritty --add-flags "--config-file ${configFile}"
    '';
  };
}
