{ config, pkgs, lib, ... }:

{
  fonts = {
    # FIXME(tweidner): Does not work under Catalina:
    # "ln: failed to create hard link: Cross-device link"
    enableFontDir = true;
    fonts = [] ++ lib.optionals (pkgs ? font-awesome_4) [
      pkgs.font-awesome_4
    ];
  } // lib.optionalAttrs pkgs.stdenvNoCC.isLinux {
    fontconfig.enable = true;
    fontconfig.dpi = 180;
  };
}
