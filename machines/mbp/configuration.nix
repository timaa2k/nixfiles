{config, lib, pkgs, ...}:

with lib;

let
  username = "tim";
  hostName = "mbp";

in rec {
  nixpkgs.config = {
    allowBroken = true;
  };
  nixpkgs.overlays =
    let path = <nixfiles/overlays>; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))
      ++ [ (import <nixfiles/homies/overlay.nix>) ];

  networking.hostName = hostName;

  nix.maxJobs = lib.mkDefault 2;

  environment.darwinConfig = <nixfiles/machines/mbp/configuration.nix>;
  system.stateVersion = 4;

  nix.nixPath = lib.mkForce [
    { darwin = <darwin>; }
    { darwin-config = <darwin-config>; }
    { nixfiles = <nixfiles>; }
    { nixpkgs = <nixpkgs>; }
    "/nix/var/nix/profiles/per-user/root/channels"
    "$HOME/.nix-defexpr/channels"
  ];

  imports = [
    <nixfiles/setup/darwin>
  ];

  nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "nix-docker";
    sshUser = "root";
    sshKey = "/etc/nix/docker_rsa";
    systems = [ "x86_64-linux" ];
    maxJobs = 2;
  }];

  services.nix-daemon.enable = true;
}
