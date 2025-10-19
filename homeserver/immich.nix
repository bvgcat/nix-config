{
  config,
  lib,
  pkgs,
  user,
  pkgs-master,
  ...
}:

let
  port = 2283;
in
{
  networking.firewall.allowedTCPPorts = [ port 3003 ];
  users.users.immich.extraGroups = [ "video" "render" ];

  systemd.services.immich-machine-learning = {
    environment = {
      MPLCONFIGDIR = "/var/lib/immich/.cache/matplotlib";
      HF_HOME      = "/var/lib/immich/.cache/huggingface";
    };
  };
  
  services = {
    immich = {
      enable = true;
      port = port;
      host = "localhost";
      group = "immich";
      package = pkgs.immich;
      openFirewall = true;
      redis.enable = true;
      accelerationDevices = null; # enable all
      mediaLocation = "/var/lib/immich";
      
      #  https://immich.app/docs/install/config-file/
      #settings = ;

      database = {
        enable = true;
        createDB = true;
      };
      machine-learning = {
        enable = true;
        environment = {};
      };
    };
  };
}
