{ config, pkgs, lib, ... }:

# nginx for part-db https://docs.part-db.de/installation/nginx.html
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "part-db.bvgcat.top" = {
        forceSSL = true;
        #root 
      };
      "nextcloud.bvgcat.top" = {

      };
    }
  };

}