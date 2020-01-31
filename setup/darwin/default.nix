{ config, pkgs, ... }:

{
  imports = [
    ../common
    ./macos-defaults.nix
    ./packages.nix
    ./window-manager.nix
  ];

  nix.extraOptions = ''
    builders = @/etc/nix/machines
  '';

#  networking.knownNetworkServices = ["Wi-Fi" "Bluetooth PAN"];
  networking.dns = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
  
  services.activate-system.enable = true;
  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;
}
