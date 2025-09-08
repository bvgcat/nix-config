{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let 
  port = 8112;
  path = "/run/media/${user}/sdcard/deluge";
in 
{
  fileSystems."/var/lib/deluge" = {
    device = path;
    options = [ "bind" ];
  };

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