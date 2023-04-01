self: super: {

  installApplication = 
    { name, appname ? name, version, src, description, homepage, 
      postInstall ? "", sourceRoot ? ".", ... }:
    with super; stdenv.mkDerivation {
      name = "${name}-${version}";
      version = "${version}";
      src = src;
      buildInputs = [ undmg unzip ];
      sourceRoot = sourceRoot;
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
	mkdir -p "$out/Applications/${appname}.app"
	cp -pR * "$out/Applications/${appname}.app"
      '' + postInstall;
      meta = with lib; {
	description = description;
	homepage = homepage;
	platforms = platforms.darwin;
      };
    };

  Alfred = self.installApplication rec {
    name = "Alfred";
    version = "5.0.6_2110";
    sourceRoot = "Alfred 5.app";
    src = super.fetchurl {
      url = "https://cachefly.alfredapp.com/Alfred_${version}.dmg";
      sha256 = "16jbycxi22zw87g64x38znlvhbfx5k4m2paiyn4rw5igpzb3h9nf";
    };
    description = "Alfred is an award-winning app for macOS which boosts your efficiency with hotkeys, keywords, text expansion and more. Search your Mac and the web, and be more productive with custom actions to control your Mac.";
    homepage = https://alfredapp.com;
  };

  # Docker = self.installApplication rec {
  #   name = "Docker";
  #   version = "4.2.0";
  #   sourceRoot = "Docker.app";
  #   src = super.fetchurl {
  #     url = "https://desktop.docker.com/mac/main/arm64/Docker.dmg";
  #     sha256 = "1k5w8737ggzzbhxkf1kgfsv59dkbqbkharx9g1v8vqfzjdflc0ay";
  #     # date = 2023-04-01
  #   };
  #   description = ''
  #     Docker Desktop for Mac is an easy-to-install application for building,
  #     debugging, and testing Dockerized apps on a Mac
  #   '';
  #   homepage = https://store.docker.com/editions/community/docker-ce-desktop-mac;
  # };

  # GoogleChrome = self.installApplication rec {
  #   name = "GoogleChrome";
  #   version = "101.0.4951.64";
  #   sourceRoot = "Google Chrome.app";
  #   src = super.fetchurl {
  #     url = "https://dl.google.com/chrome/mac/universal/stable/CHFA/googlechrome.dmg";
  #     sha256 = "0vj3l4gagy7ln5nq4njps5g1mijdp1hy34rc51ckcxsfq7riih7a";
  #     # date = 2023-04-01
  #   };
  #   description = ''
  #     Google Chrome is a cross-platform web browser developed by Google.
  #   '';
  #   homepage = http://google.com/chrome/;
  # };

}
