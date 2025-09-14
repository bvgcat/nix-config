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
    ./networking.nix
    ./settings.nix
    ./ssh.nix
    ./syncthing.nix
  ];
}