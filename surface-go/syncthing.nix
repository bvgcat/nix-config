{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.syncthing = {
    enable = true;
    package = pkgs.syncthing;
    configDir = "/home/h/.config/syncthing";
    user = "h";
  };
  networking.firewall.allowedTCPPorts = [
    8384
    22000
  ];
  networking.firewall.allowedUDPPorts = [
    21027
    22000
  ];
}