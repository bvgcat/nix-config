{
  config,
  pkgs,
  lib,
  ...
}:

{

  programs.bash = {
    #shellInit = {
    #  "export PATH=$HOME/arm/bin:$PATH"

    #};

    shellAliases = {
      q = "exit ";
      c = "clear ";

      h = "cd ";
      uni = "cd /home/h/University/24-WiSe";
      root = "cd /";

      rkde = "kstart5 plasmashell";
      clean = "sudo nix-collect-garbage -v -d && sudo nix-store -v --gc && sudo nix-store -v --optimise";
      update = "sudo nixos-rebuild switch --flake /home/h/nix-config";
      upgrade = "sudo nix flake update --flake /home/h/nix-config && sudo nixos-rebuild switch --flake /home/h/nix-config";
      uptermlocal = "nixos-rebuild --target-host root@192.168.178.200 switch --flake /home/h/nix-config";
      uptermexternal = "nixos-rebuild --build-host root@192.168.0.200 --target-host root@192.168.0.200 switch --flake .#partdb-terminal";
    };
  };
}
