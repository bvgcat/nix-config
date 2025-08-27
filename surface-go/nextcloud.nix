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
      hostName = "cloud.bvgcat.de";
      datadir = "/run/media/${user}/sdcard/nextcloud";
      # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud31;

      # Let NixOS install and configure the database automatically.
      database.createLocally = true;

      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;

      # Increase the maximum file upload size to avoid problems uploading videos.
      maxUploadSize = "16G";
      https = true;
      #overwriteprotocol = "https";
      autoUpdateApps = {
        enable = true;
        startAt = "02:00:00";
      };
      #extraAppsEnable = false;
      #extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
      #  inherit calendar contacts notes;

        # Custom app installation example.
        #cookbook = pkgs.fetchNextcloudApp rec {
        #  url =
        #    "https://github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
        #  sha256 = "sha256-XgBwUr26qW6wvqhrnhhhhcN4wkI+eXDHnNSm1HDbP6M=";
        #};
      #};

      config = {
        #overwriteprotocol = "http";
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = "/run/secrets/nc-adminpass";
      };

      #ensureUsers = {
      #  mira = {
      #    email = "miratamim.tm@gmail.com";
      #    passwordFile = "/run/secrets/nc-userpass";
      #  };
      #};

      settings = {
        default_phone_region = "DE";
        trusted_domains = [ "localhost" ];
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
