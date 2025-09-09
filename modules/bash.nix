{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.bash.shellAliases = {
    q = "exit ";
    c = "clear ";

    h = "cd ";
    uni = "cd /home/h/University/24-WiSe";
    root = "cd /";

    rkde = "kstart5 plasmashell";
    clean = "sudo nix-collect-garbage -v -d && sudo nix-store -v --gc && sudo nix-store -v --optimise";
    update = "sudo nix flake update --flake /home/h/nix-config";
    upgrade = "sudo nix flake update --flake /home/h/nix-config && sudo nixos-rebuild switch --flake /home/h/nix-config";
    upgrade-hs-here = "nixos-rebuild --target-host root@bvgcat.de switch --flake /home/h/nix-config#homeserver";
    upgrade-hs-there = "nixos-rebuild --build-host root@bvgcat.de --target-host root@bvgcat.de switch --flake /home/h/nix-config#homeserver";
  };
}
