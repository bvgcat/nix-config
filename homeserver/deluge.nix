{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let 
  port = 8112;
in 
{
  services.deluge = {
    enable = true;
    dataDir = "/var/lib/deluge";
    #declarative = true;
    web = {
      enable = true;
      port = port;
      openFirewall = true;
    }; 
  };
}