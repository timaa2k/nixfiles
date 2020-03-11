{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./packages.nix
    ./shells.nix
  ];

  time.timeZone = "Europe/Berlin";
}
