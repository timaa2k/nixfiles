{ config, pkgs, headless, ... }:

let
  mkCache = url: key: { inherit url key; };
  caches =
    let
      nixos = mkCache "https://cache.nixos.org" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
      peel = mkCache "https://peel.cachix.org" "peel.cachix.org-1:juIxrHgL76bYKcfIB/AdBUQuwkTwW5OLpPvWNuzhNrE=";
      cachix = mkCache "https://cachix.cachix.org" "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
      hercules-ci = mkCache "https://hercules-ci.cachix.org" "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0=";
      hie-nix = mkCache "https://hie-nix.cachix.org" "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY=";
      all-hies = mkCache "https://all-hies.cachix.org" "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k=";
      nix-tools = mkCache "https://nix-tools.cachix.org" "nix-tools.cachix.org-1:ebBEBZLogLxcCvipq2MTvuHlP7ZRdkazFSQsbs0Px1A=";
    in [ nixos peel cachix hercules-ci hie-nix all-hies nix-tools ];
in {
  nix.binaryCaches = builtins.map (x: x.url) caches;
  nix.binaryCachePublicKeys = builtins.map (x: x.key) caches;

  nix.trustedUsers = [ "@admin" "root" ];

  nix.useSandbox = true;
  nix.sandboxPaths = [] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    "/System/Library/Frameworks"
    "/System/Library/PrivateFrameworks"
    "/usr/lib"
    "/private/tmp"
    "/private/var/tmp"
    "/usr/bin/env"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreeRedistributable = true;

  environment.systemPackages = with pkgs; [
    dot-git
    dot-lf
    dot-tmux
    dot-neovim
    (python3.withPackages (p: with p; [
    ]))
    nodejs
    ripgrep
    fzf
    fd
    bat
    tmuxp
    niv

    go
    godef
    gotools
    gopls

    alacritty
    kitty
    bash-completion
    # cachix
    cmake
    direnv
    exa
    findutils
    coreutils
    docker-compose
    gnumake
    ps

    kind
    s3fs

    htop
    jq
    nix-prefetch-scripts
    tree
    unzip
    vscode-with-extensions
    youtube-dl
  ];
}
