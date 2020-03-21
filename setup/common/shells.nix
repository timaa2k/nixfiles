{ config, pkgs, ...}:

{
  environment.shells = [ pkgs.bash ];
  programs.bash.enable = true;
  programs.bash.enableCompletion = true;
  environment.etc."bash.local".text = builtins.readFile ../../homies/bash/bashrc;
}
