{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    skhd
    Alfred
    #Docker
    #GoogleChrome
  ];
}
