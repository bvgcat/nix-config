{ config, pkgs, lib, ... }:

{
  environment.etc."nextcloud-admin-pass".text = "PWD";
  services.nextcloud = {
    enable = true;
    configureRedis = true;
    package = pkgs.nextcloud31;
    hostName = "localhost";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "pgsql";
    
    maxUploadSize = "10G";
    
    ensureUsers = {
      admin = {
        email = "hamzatamim.ht@gamil.com";
      };
      #mira = {
      #  email = "mira@localhost";
      #  passwordFile = "/etc/nextcloud-user-pass";
      #};
    };

    settings = {
      mail_smtpmode = "sendmail";
      mail_sendmailmode = "pipe";
    };

    settings.enabledPreviewProviders = [
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

    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    };
  };
}