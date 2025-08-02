{ config, lib, pkgs, ... }:

{
  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "immich.bvgcat.de";
      package = pkgs.immich;
      openFirewall = true;
      redis.enable = true;
      accelerationDevices = null; # enable all
      #mediaLocation = ;

      #  https://immich.app/docs/install/config-file/
      #  https://my.immich.app/admin/system-settings
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
