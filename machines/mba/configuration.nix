{config, lib, pkgs, ...}:

with lib;

let
  username = "tim";
  hostName = "mba";

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

  environment.darwinConfig = <nixfiles/machines/mba/configuration.nix>;
  system.stateVersion = 4;

  nix.nixPath = lib.mkForce [
    { darwin = <darwin>; }
    { darwin-config = <darwin-config>; }
    { nixfiles = <nixfiles>; }
    { nixpkgs = <nixpkgs>; }
    "/nix/var/nix/profiles/per-user/root/channels"
    "$HOME/.nix-defexpr/channels"
  ];
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    system = aarch64-darwin
    extra-platforms = x86_64-darwin aarch64-darwin
    experimental-features = nix-command flakes
    build-users-group = nixbld
  '';

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
