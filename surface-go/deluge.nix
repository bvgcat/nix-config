{
  config,
  lib,
  pkgs,
  user,
  pkgs-master,
  ...
}:

{
  services.deluge = {
    enable = true;
  };
}