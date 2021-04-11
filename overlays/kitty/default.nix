self: super:

let
  execPath = if self.stdenv.isDarwin then "Applications/kitty.app/Contents/MacOS" else "bin";
  configFile = self.writeTextFile {
    name = "kitty.conf";
    text = builtins.readFile ./kitty.conf;
  };
in
{
  kitty = self.stdenv.mkDerivation {
    name = "kittyConf";
    buildInputs = [ self.makeWrapper ];
    propagatedBuildInputs = [ super.kitty ];
    phases = [ "buildPhase" ];
    buildCommand = ''
      mkdir -p $out/bin
      makeWrapper ${super.kitty}/${execPath}/kitty $out/bin/kitty --add-flags "--config ${configFile}"
    '';
  };
}
