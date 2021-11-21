{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    skhd
    Alfred
    #Calibre
    #Dash
    Docker
    GoogleChrome
    #Slack
    #Skype
    #osxfuse
  ];
}
