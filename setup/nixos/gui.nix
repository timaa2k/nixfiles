{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.peel.gui;
in {
  options.peel.gui.enable = mkEnableOption "gui";
  
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      acpi
      arandr
      autorandr
      blueman
      bluez
      dunst
      feh
      iw
      keybase
      libnotify
      powertop
      rofi
      rofi-emoji
      rofi-pass
      rofi-wifi-menu
      scrot
      stalonetray
      unclutter-xfixes
      wirelesstools
      xclip xsel
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-dropbox-plugin
      xfce.thunar_volman
      xfce.xfce4_power_manager
      xorg.libXrandr
      xorg.xbacklight
      xorg.xcursorthemes
      xorg.xf86inputkeyboard
    ];
  };
}
