{
  config,
  lib,
  pkgs,
  user,
  pkgs-master,
  ...
}:

let
  sdcardpath = "/run/media/${user}/sdcard";
  port = 2283;
in
{
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
      mediaLocation = "${sdcardpath}" + "/immich";
      
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
