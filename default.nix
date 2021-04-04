{ pkgs ? import <nixpkgs> {}
, machine ? "mbp"
, repoUrl ? "https://github.com/timaa2k/nixfiles.git"
, targetDir ? "$HOME"
}:

let
  nixPath = pkgs.stdenvNoCC.lib.concatStringsSep ":" [
    "nixpkgs=${targetDir}/nixfiles/nixpkgs-channel"
    "darwin=${targetDir}/nixfiles/nix-darwin"
    "darwin-config=${targetDir}/nixfiles/machines/mbp/configuration.nix"
    "nixfiles=${targetDir}/nixfiles"
  ];

  install = pkgs.writeScript "install" ''
    set -e
    echo >&2 "Installing..."
    if [ ! -d ${targetDir}/nixfiles ]; then
        echo "Setting up nixfiles repository" >&2
        mkdir -p ${targetDir}/nixfiles
        ${pkgs.git}/bin/git clone ${repoUrl} ${targetDir}/nixfiles
    fi
    export NIX_PATH=${nixPath}
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isLinux ''
      echo >&2 "Linking..."
      if test -e /etc/nixos/; then sudo mv /etc/nixos /etc/nixos.bak; fi
      sudo ln -fs ${targetDir}/nixfiles/machines/$1 /etc/nixos
    ''}
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isDarwin ''
    echo "Ensuring nix-darwin exists..."
    if [ ! -d /run ]; then
      sudo ln -fs /private/var/run /run
    fi
    if (! command -v darwin-rebuild); then
      echo >&2 "Installing nix-darwin..."
      $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
    fi
    if test -e /etc/static/bashrc; then . /etc/static/bashrc; fi
      echo >&2 "Building initial configuration..."
      $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch
    ''}
  '';

  uninstall = pkgs.writeScript "uninstall" ''
    set -e
    echo >&2 "Uninstalling..."
    export NIX_PATH=${nixPath}
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isDarwin ''
    echo "Ensuring nix-darwin does not exist..."
    if test -L /run/current-system; then
      if (command -v /run/current-system/sw/bin/darwin-rebuild); then
        echo >&2 "Uninstalling nix-darwin..."
        /run/current-system/sw/bin/darwin-rebuild switch -I "darwin-config=${targetDir}/nixfiles/nix-darwin/pkgs/darwin-uninstaller/configuration.nix"
	sudo rm /run/current-system
      fi
    fi
    ''}
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isLinux ''
    echo >&2 "Unlinking..."
    if test -e /etc/nixos; then sudo rm /etc/nixos; fi
    if test -e /etc/nixos.bak; then sudo mv /etc/nixos.bak /etc/nixos; fi
    ''}
  '';

  switch = pkgs.writeScript "switch" ''
    set -e
    echo >&2 "Switching..."
    cd ${targetDir}/nixfiles
    echo >&2 "Tagging working config..."
    git branch -f update HEAD
    echo >&2 "Switching environment..."
    export NIX_PATH=${nixPath}
    ${if pkgs.stdenvNoCC.isDarwin then "darwin" else "nixos"}-rebuild switch
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isDarwin ''
      echo "Current generation: $(darwin-rebuild --list-generations | tail -1)"
    ''}
    echo >&2 "Tagging updated..."
    git branch -f working update
    git branch -D update
    git push
    cd -
  '';


in pkgs.stdenvNoCC.mkDerivation {
  name = "nixfiles";
  preferLocalBuild = true;
  propagatedBuildInputs = [ pkgs.git ];
  #propagatedUserEnvPkgs = [ pkgs.git ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    echo "$shellHook" > $out/bin/nixfiles
    chmod +x $out/bin/nixfiles
  '';

  shellHook = ''
    set -e
    while [ "$#" -gt 0 ]; do
        i="$1"
        case "$i" in
            install)
                shift
                ${install} "$@"
                exit
                ;;
            switch)
                ${switch}
                exit
                ;;
            uninstall)
                ${uninstall}
                exit
                ;;
            *)
                echo "nixfiles: [help] [install machine-name] [uninstall] [switch]"
                exit
                ;;
        esac
    done
    exit
  '';

  passthru.check = pkgs.stdenvNoCC.mkDerivation {
     name = "run-nixfiles-test";
     shellHook = ''
        set -e
        echo >&2 "running nixfiles tests..."
        echo >&2 "checking repository"
        test -d ${targetDir}
        exit
    '';
  };
}
