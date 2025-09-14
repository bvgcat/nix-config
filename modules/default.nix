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
    ./ssh.nix
    ./syncthing.nix
  ];
}