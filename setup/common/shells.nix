{ config, pkgs, ...}:

{
  environment.shells = [ pkgs.zsh ];

  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;
  programs.zsh.enableFzfCompletion = true;
  programs.zsh.enableFzfGit = true;
  programs.zsh.enableFzfHistory = true;

  environment.shellAliases = {
    less = "less -R";
    tailf = "tail -f";
    ls = "ls -Gh";
    ll = "ls -al";
    df = "df -h";
    du = "du -h -d 2";
    grep = "${pkgs.ripgrep}/bin/rg";
    rebuild = if pkgs.stdenvNoCC.isLinux then "nixos-rebuild" else "darwin-rebuild";
  };
  
}
