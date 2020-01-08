{ pkgs ? import <nixpkgs> {}
, machine ? "mbp"
, repoUrl ? "https://github.com/timaa2k/nixfiles.git"
, nurpkgs ? "https://github.com/peel/nur-packages.git"
, targetDir ? "$HOME/wrk"
}:

let
  rebuildCmd = "${if pkgs.stdenvNoCC.isDarwin then "darwin" else "nixos"}-rebuild";

  darwin = ''
    echo >&2 "Building initial configuration..."
    if test -e /etc/static/bashrc; then . /etc/static/bashrc; fi
    /run/current-system/sw/bin/darwin-rebuild switch \
        -I "darwin-config=$HOME/.config/nixpkgs/machines/darwin/configuration.nix" \
        -I "nixpkgs-overlays=$HOME/.config/nixpkgs/overlays" \
        -I "nurpkgs-peel=$HOME/.config/nurpkgs" \
        -I "nixfiles=$HOME/.config/nixpkgs"
  '';

  install = pkgs.writeScript "install" ''
    set -e
    echo >&2 "Installing..."
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isDarwin ''
    echo "Setting up/tm nix-darwin..."
    if (! command -v darwin-rebuild); then
        echo >&2 "Installing nix-darwin..."
        mkdir -p ./nix-darwin && cd ./nix-darwin
        nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
        yes | ./result/bin/darwin-installer
        cd .. && rm -rf ./nix-darwin
    fi
    ''}

    if [ ! -d ${targetDir}/nurpkgs ]; then
        echo "Setting up nurpkgs repository" >&2
        mkdir -p ${targetDir}
        git clone ${nurpkgs} ${targetDir}/nurpkgs
    fi

    if [ ! -d ${targetDir}/nixfiles ]; then
        echo "Setting up nixfiles repository" >&2
        mkdir -p ${targetDir}/nixfiles
        git clone ${repoUrl} ${targetDir}/nixfiles
    fi

    ${link} "$@"
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isDarwin darwin}
  '';

  link = pkgs.writeScript "link" ''
    set -e
    echo >&2 "Linking..."
    echo "$@"
    mkdir -p ~/.config
    ln -fs ${targetDir}/nurpkgs ~/.config/nurpkgs
    ln -fs ${targetDir}/nixfiles ~/.config/nixpkgs
    ${pkgs.lib.optionalString pkgs.stdenvNoCC.isLinux ''
    if test -e /etc/nixos/; then sudo mv /etc/nixos /etc/nixos.bak; fi
    sudo ln -fs ${targetDir}/nixfiles/machines/$1 /etc/nixos
    ''}
  '';

  unlink = pkgs.writeScript "unlink" ''
    set -e
    echo >&2 "Unlinking..."
    if test -e ~/.config/nixpkgs; then rm -rf ~/.config/nixpkgs; fi
    if test -e /etc/nixos; then sudo rm /etc/nixos; fi
    if test -e /etc/nixos.bak; then sudo mv /etc/nixos.bak /etc/nixos; fi
  '';

  uninstall = pkgs.writeScript "uninstall" ''
    ${unlink}
    echo >&2 "Cleaning up..."
    if test -e ~/.config/nurpkgs; then rm -rf ~/.config/nurpkgs; fi
  '';

  switch = pkgs.writeScript "switch" ''
    set -e
    cd ${targetDir}/nixfiles
    echo >&2 "Tagging working config..."
    git branch -f update HEAD
    echo >&2 "Switching environment..."
    ${rebuildCmd} switch
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
            link)
                shift
                ${link} "$@"
                exit
                ;;
            switch)
                ${switch}
                exit
                ;;
            unlink)
                ${unlink}
                exit
                ;;
            uninstall)
                ${uninstall}
                exit
                ;;
            help)
                echo "nixfiles: [help] [install machine-name] [uninstall] [link machine-name] [unlink] [switch]"
                exit
                ;;
            *)
               ${rebuildCmd} "$@"
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
