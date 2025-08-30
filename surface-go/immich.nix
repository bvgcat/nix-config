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
  path = "/run/media/${user}/sdcard/immich";
in
{
  networking.firewall.allowedTCPPorts = [ port ];

  systemd.tmpfiles.rules = [ "d ${path} 0750 immich immich -" ];

  fileSystems."/var/lib/immich" = {
    device = path;
    options = [ "bind" ];
  };

  services = {
    immich = {
      enable = true;
      port = port;
      host = "localhost";
      group = "services";
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
        #environment = { MACHINE_LEARNING_MODEL_TTL = "600"; };
      };
    };
  };
}
