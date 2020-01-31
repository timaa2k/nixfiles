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
      meta = with stdenv.lib; {
	description = description;
	homepage = homepage;
	platforms = platforms.darwin;
      };
    };

  Alfred = self.installApplication rec {
    name = "Alfred";
    version = "4.0.8_1135";
    sourceRoot = "Alfred 4.app";
    src = super.fetchurl {
      url = "https://cachefly.alfredapp.com/Alfred_${version}.dmg";
      sha256 = "0f6l8xs0pm7z2c3ll55k5cl2mgc0xvdxkqkgpr9aswjjdm4n0v7j";
      # date = 2020-01-31T07:15:13+0100;
    };
    description = "Alfred is an award-winning app for macOS which boosts your efficiency with hotkeys, keywords, text expansion and more. Search your Mac and the web, and be more productive with custom actions to control your Mac.";
    homepage = https://alfredapp.com;
  };

  Calibre = self.installApplication rec {
    name = "Calibre";
    version = "4.9.1";
    sourceRoot = "Calibre.app";
    src = super.fetchurl {
      url = "https://download.calibre-ebook.com/${version}/calibre-${version}.dmg";
      sha256 = "0r7pjhq59jmfvia12wxp5s86ijwv76k0iybjjwkxqs7nlwan1alp";
      # date = 2020-01-31T07:25:13+0100;
    };
    description = "Calibre is a one stop solution for all your ebook needs.";
    homepage = https://calibre-ebook.com;
    # appcast = https://github.com/kovidgoyal/calibre/releases.atom;
  };
  
  Dash = self.installApplication rec {
    name = "Dash";
    version = "5.1.2";
    sourceRoot = "Dash.app";
    src = super.fetchurl {
      url = https://kapeli.com/downloads/v5/Dash.zip;
      sha256 = "10rcgz7cgq9ihh6xxh0j0rvnymh7wiawxni3m4zg6kh6p2ijlqjk";
      # date = 2020-01-31T07:21:13+0100;
    };
    description = "Dash is an API Documentation Browser and Code Snippet Manager";
    homepage = https://kapeli.com/dash;
  };

  Docker = self.installApplication rec {
    name = "Docker";
    version = "2.2.0.0";
    versionId = "31259";
    sourceRoot = "Docker.app";
    src = super.fetchurl {
      url = "https://download.docker.com/mac/stable/Docker.dmg";
      sha256 = "0b80j320wnidc13w38b1m68r2adf7skgxnmhk8zbxmrksn7nrrgh";
      # date = 2020-01-31T07:37:13+0100;
    };
    description = ''
      Docker CE for Mac is an easy-to-install desktop app for building,
      debugging, and testing Dockerized apps on a Mac
    '';
    homepage = https://store.docker.com/editions/community/docker-ce-desktop-mac;
  };

  GoogleChrome = self.installApplication rec {
    name = "GoogleChrome";
    version = "79.0.3945.123";
    sourceRoot = "Google Chrome.app";
    src = super.fetchurl {
      url = "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg";
      sha256 = "19vcpw5jxvrdn28fha5kyw8bfvkndwpv977m249nidawrvq98qyr";
      # date = 2020-01-31T08:42:13+0100;
    };
    description = ''
      Google Chrome is a cross-platform web browser developed by Google.
    '';
    homepage = http://google.com/chrome/;
  };

}
