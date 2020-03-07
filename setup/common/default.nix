{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./git.nix
    ./packages.nix
    ./shells.nix
  ];

  time.timeZone = "Europe/Berlin";
}
