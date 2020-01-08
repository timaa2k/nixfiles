{ config, pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./fonts.nix
    ./git.nix
    ./gnupg.nix
    ./packages.nix
    ./shells.nix
    ./tmux.nix
  ];

  time.timeZone = "Europe/Berlin";
}
