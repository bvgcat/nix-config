{
  config,
  pkgs,
  lib,
  hostname,
  ...
}:

{
  imports = [
    ./bash.nix
    ./settings.nix
    ./syncthing.nix
  ];
}