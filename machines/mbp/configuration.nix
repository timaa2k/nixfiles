{config, lib, pkgs, ...}:

with lib;

let
  sources = import <nixfiles/pinned> { inherit (pkgs) fetchgit lib; };
  username = "tim";
  hostName = "mbp";

in rec {
  nixpkgs.overlays =
    let path = <nixfiles/overlays>; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))
      ++ [ (import <nurpkgs-peel/overlay.nix>) ];

  #networking.hostName = hostName;

  nix.maxJobs = lib.mkDefault 2;

  environment.darwinConfig = <nixfiles/machines/mbp/configuration.nix>;
  system.stateVersion = 4;

  nix.nixPath = [
    { darwin = "${sources.nix-darwin}"; }
    { darwin-config = "${environment.darwinConfig}"; }
    { nixpkgs = "${sources.nixpkgs}"; }
    { nixfiles = "$HOME/.config/nixpkgs"; }
    { nurpkgs-peel = "${sources.nurpkgs}"; }
    "$HOME/.nix-defexpr/channels"
  ];

  imports = let modules = (import <nurpkgs-peel/darwin-modules>); in [
    modules.yabai
    <nixfiles/setup/darwin>
  ];
}
