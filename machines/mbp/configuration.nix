{config, lib, pkgs, ...}:

with lib;

let
  username = "tim";
  hostName = "mbp";

in rec {
  nixpkgs.overlays =
    let path = <nixfiles/overlays>; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))
      ++ [ (import <nur-packages/overlay.nix>) ];

  networking.hostName = hostName;

  nix.maxJobs = lib.mkDefault 2;

  environment.darwinConfig = <nixfiles/machines/mbp/configuration.nix>;
  system.stateVersion = 4;

  nix.nixPath = lib.mkForce [
    { darwin = <darwin>; }
    { darwin-config = <darwin-config>; }
    { nixfiles = <nixfiles>; }
    { nixpkgs = <nixpkgs>; }
    { nur-packages = <nur-packages>; }
    "/nix/var/nix/profiles/per-user/root/channels"
    "$HOME/.nix-defexpr/channels"
  ];

  imports = let modules = (import <nur-packages/darwin-modules>); in [
    modules.yabai
    <nixfiles/setup/darwin>
  ];
}
