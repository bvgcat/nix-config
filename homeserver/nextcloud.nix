{
  self,
  config,
  lib,
  pkgs,
  user,
  ...
}:

let 
  ports = [ 80 443 ];
in 
{
  networking.firewall.allowedTCPPorts = ports;

  services = {
    nextcloud = {
      enable = true;
      hostName = "cloud.homeserver";
      datadir = "/var/lib/nextcloud";
        
      # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud32;

      # Let NixOS install and configure the database automatically.
      database.createLocally = true;

      # Increase the maximum file upload size to avoid problems uploading videos.
      maxUploadSize = "16G";
      https = true;

      appstoreEnable = true;
      autoUpdateApps = {
        enable = true;
        startAt = "02:00:00";
      };

      config = {
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = "/run/secrets/nc-adminpass";
      };

      settings = {
        default_phone_region = "DE";    
        trusted_domains = [ "cloud.homeserver" "localhost" "homeserver" ];
        overwrite.cli.url = "http://cloud.homeserver";
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
        ];
      };
    };
  };

  users.users.immich.extraGroups = [ "services" ];
}
