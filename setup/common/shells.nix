{ config, pkgs, ...}:

{
  environment.shells = [ pkgs.bash ];
  programs.bash.enable = true;
  programs.bash.enableCompletion = true;

  # NOTE(timaa2k): nix-darwin loads custom bashrc from this location.
  # https://github.com/LnL7/nix-darwin/blob/1ffae69c561c67087f5023aa8b6b3dcc6078b04d/modules/programs/bash/default.nix#L97
  environment.etc."bash.local".text = builtins.readFile ../../homies/bash/bashrc;
}
