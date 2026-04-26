{
  config,
  pkgs,
  lib,
  hostname,
  ...
}:

{
  imports = [
    ../secrets/sops.nix

    ./bash.nix
    ./networking.nix
    ./settings.nix
    ./ssh.nix
    ./syncthing.nix
  ];
}