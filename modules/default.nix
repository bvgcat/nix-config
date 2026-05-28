{
  ...
}:

{
  imports = [
    ../secrets/sops.nix

    ./bash.nix
    ./networking.nix
    ./ssh.nix
    ./syncthing.nix
  ];
}