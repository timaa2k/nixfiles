{ config, pkgs, lib, ... }:

{
  fonts = {
    # FIXME(tweidner): Does not work under Catalina due to symlinks.
    enableFontDir = true;
    fonts = [] ++ lib.optionals (pkgs ? font-awesome_4) [
      pkgs.font-awesome_4
    ];
  } // lib.optionalAttrs pkgs.stdenvNoCC.isLinux {
    fontconfig.enable = true;
    fontconfig.dpi = 180;
  };
}
