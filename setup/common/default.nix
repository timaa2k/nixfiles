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

  peel.secrets.enable = true;

  time.timeZone = "Europe/Warsaw";
}
