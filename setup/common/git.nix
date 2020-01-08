{ config, pkgs, lib, ... }:

with lib;

let
  gitignore = pkgs.writeText "gitignore.global" ''
    *~
    .Trash-*
    .nfs*
    .DS_Store
    ._*
    .Spotlight-V100
    .Trashes
    \#*\#
    *.elc
    tramp
    .\#*
    result/
    .envrc
  '';

  gitConfig = {
    user = {
      email = "timaa2k@gmail.com";
      name = "Tim Weidner";
    };

    github.user = "timaa2k";

    #use.signingkey = "timaa2k@gmail.com";
    #commit.gpgsign = true;

    color.ui = true;
    format.pretty = "format:%C(blue)%ad%Creset %C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an]%Creset";

    mergetool.prompt = false;
    merge = {
      summary = true;
      verbosity = 1;
      ff = "only";
      conflictstyle = "diff3";
    };

    diff = {
      mnemonicPrefix = true;
      algorithm = "patience";
    };

    apply.whitespace = "nowarn";
    branch.autosetuprebase = "always";
    push.default = "upstream";

    core = {
      autocrlf = false;
      excludefile = "${gitignore}";
    };

    advice.statusHints = false;
  };

in {
  environment.systemPackages = with pkgs; [
    git
  ];
  
  environment.shellAliases = {
    log = "git log --pretty --graph";
  };
  
  environment.etc."gitconfig".text = generators.toINI {} gitConfig;
}
