{ config, pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./fonts.nix
    ./git.nix
    ./packages.nix
    ./shells.nix
    ./tmux.nix
  ];

  time.timeZone = "Europe/Berlin";
}
