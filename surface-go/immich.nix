{
  config,
  lib,
  pkgs,
  ...
}:

{
  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "localhost";
      package = pkgs.immich;
      openFirewall = true;
      redis.enable = true;
      accelerationDevices = null; # enable all
      #mediaLocation = ;

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
