{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  users.users.h.extraGroups = [ "docker" ];
  virtualisation.docker.daemon.settings = {
  #  data-root = "/some-place/to-store-the-docker-data";
  };

}