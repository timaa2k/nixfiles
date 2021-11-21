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
    version = "4.5.1_1256";
    sourceRoot = "Alfred 4.app";
    src = super.fetchurl {
      url = "https://cachefly.alfredapp.com/Alfred_${version}.dmg";
      sha256 = "0i0k7apxnlk4ppmjgzg83p96l1rdxwxpd194n7nf6myhqv8nc86c";
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
    version = "6.0.2";
    sourceRoot = "Dash.app";
    src = super.fetchurl {
      url = https://kapeli.com/downloads/v5/Dash.zip;
      sha256 = "1a145hb0qanij6r5wq6snw4vk0zb6n57v3y9shngz0psdd4v966d";
      # date = 2020-08-03T19:56:00+0100;
    };
    description = "Dash is an API Documentation Browser and Code Snippet Manager";
    homepage = https://kapeli.com/dash;
  };

  Docker = self.installApplication rec {
    name = "Docker";
    version = "4.2.0";
    sourceRoot = "Docker.app";
    src = super.fetchurl {
      url = "https://desktop.docker.com/mac/main/arm64/Docker.dmg";
      sha256 = "0lz8lcr661inwlafd7c0d9vp90p6x61bl8qpcxv08rl4clfk3lks";
      # date = 2021-11-21T19:56:00+0100;
    };
    description = ''
      Docker Desktop for Mac is an easy-to-install application for building,
      debugging, and testing Dockerized apps on a Mac
    '';
    homepage = https://store.docker.com/editions/community/docker-ce-desktop-mac;
  };

  GoogleChrome = self.installApplication rec {
    name = "GoogleChrome";
    version = "95.0.4638.69";
    sourceRoot = "Google Chrome.app";
    src = super.fetchurl {
      url = "https://dl.google.com/chrome/mac/universal/stable/CHFA/googlechrome.dmg";
      sha256 = "1mhn6j20f44jq1hjn9cqbbkg2jkhlnnfpksssvy7i543ibng56vj";
      # date = 2021-11-06T19:56:00+0100;
    };
    description = ''
      Google Chrome is a cross-platform web browser developed by Google.
    '';
    homepage = http://google.com/chrome/;
  };

  # FIXME(tweidner): Electron problem - fails with error:
  # "LSOpenURLsWithRole() failed with error -10810"
  Slack = self.installApplication rec {
    name = "Slack";
    version = "4.14.0";
    sourceRoot = "Slack.app";
    src = super.fetchurl {
      url = "https://downloads.slack-edge.com/releases/macos/${version}/prod/universal/Slack-${version}-macOS.dmg";
      sha256 = "1vb47c69wspils0w6xipcbn6gkiyjc7hfkfwvz4gaf2k7x1hqkzx";
      # date = 2021-03-17T09:29:13+0100;
    };
    description = ''
      Slack is a cloud-based proprietary instant messaging platform developed by Slack Technologies.
    '';
    homepage = https://slack.com/intl/en-hk/;
  };

  # FIXME(tweidner): Electron problem - fails with error:
  # "LSOpenURLsWithRole() failed with error -10810"
  Skype = self.installApplication rec {
    name = "Skype";
    version = "8.56.0.106";
    sourceRoot = "Skype.app";
    src = super.fetchurl {
      url = "https://download.skype.com/s4l/download/mac/Skype-${version}.dmg";
      sha256 = "1nvn6ipbpd5p6x39my9nsnn5fp47yy4z8z0dgd90a6zfb852a8wm";
      # date = 2020-02-14T19:57:13+0100;
    };
    description = ''
      Skype is a telecommunications application that specializes in providing video chat via the Internet.
    '';
    homepage = https://www.skype.com/de/get-skype/;
  };

}
