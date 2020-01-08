{config, lib, pkgs, ...}:

with lib;

let
  sources = import <dotfiles/pinned> { inherit (pkgs) fetchgit lib; };
  username = "tim";
  hostName = "mbp";

in rec {
  nixpkgs.overlays =
    let path = <dotfiles/overlays>; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))
      ++ [ (import <nurpkgs-peel/overlay.nix>) ];

  networking.hostName = hostName;

  nix.maxJobs = lib.mkDefault 12;

  environment.darwinConfig = <dotfiles/machines/mbp/configuration.nix>;
  system.stateVersion = 3;

  nix.nixPath = [
    "darwin-config=${environment.darwinConfig}"
    "darwin=${sources."nix-darwin"}"
    "nixpkgs=${sources.nixpkgs}"
    "dotfiles=$HOME/.config/nixpkgs"
    "nurpkgs-peel=${sources.nurpkgs}"
    "$HOME/.nix-defexpr/channels"
    "$HOME/.nix-defexpr"
  ];

  imports = let modules = (import <nurpkgs-peel/darwin-modules>); in [
    modules.yabai
    <dotfiles/setup/darwin>
  ];
}
