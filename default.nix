{ pkgs ? import <nixpkgs> {}
, machine ? "mbp"
, repoUrl ? "https://github.com/timaa2k/nixfiles.git"
, targetDir ? "$HOME"
}:

let
  install = pkgs.writeScript "install" ''
    set -e
    echo >&2 "Installing..."
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isDarwin ''
    echo "Ensuring nix-darwin exists..."
    if (! command -v darwin-rebuild); then
	echo >&2 "Installing nix-darwin..."
	nix-build ${targetDir}/nixfiles/nix-darwin -A installer
	${targetDir}/nixfiles/result/bin/darwin-installer && rm -rf ${targetDir}/nixfiles/result
    fi
    ''}
    if [ ! -d ${targetDir}/nixfiles ]; then
        echo "Setting up nixfiles repository" >&2
        mkdir -p ${targetDir}/nixfiles
        git clone ${repoUrl} ${targetDir}/nixfiles
    fi
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isLinux ''
      echo >&2 "Linking..."
      if test -e /etc/nixos/; then sudo mv /etc/nixos /etc/nixos.bak; fi
      sudo ln -fs ${targetDir}/nixfiles/machines/$1 /etc/nixos
    ''}

    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isDarwin ''
      echo >&2 "Building initial configuration..."
      if test -e /etc/static/bashrc; then . /etc/static/bashrc; fi
      NIX_PATH=$HOME/.nix-defexpr/channels:$NIX_PATH \
      /run/current-system/sw/bin/darwin-rebuild switch \
          -I "nixfiles=${targetDir}/nixfiles" \
          -I "nixpkgs=${targetDir}/nixfiles/nixpkgs-channels" \
          -I "darwin=${targetDir}/nixfiles/nix-darwin" \
          -I "darwin-config=${targetDir}/nixfiles/machines/mbp/configuration.nix" \
          -I "nur-packages=${targetDir}/nixfiles/nur-packages"
    ''}
  '';

  uninstall = pkgs.writeScript "uninstall" ''
    set -e
    echo >&2 "Uninstalling..."
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isDarwin ''
    echo "Ensuring nix-darwin does not exist..."
    if (command -v darwin-rebuild); then
	echo >&2 "Uninstalling nix-darwin..."
	nix-build ${targetDir}/nixfiles/nix-darwin -A uninstaller
	${targetDir}/nixfiles/result/bin/darwin-uninstaller && rm -rf ${targetDir}/nixfiles/result
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
    cd ${targetDir}/nixfiles
    echo >&2 "Tagging working config..."
    git branch -f update HEAD
    echo >&2 "Switching environment..."
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
  propagatedUserEnvPkgs = [ pkgs.git ];
  
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
