{
  config,
  pkgs,
  lib,
  user,
  ...
}:

{
  programs.bash.shellAliases = {
    q = "exit ";
    c = "clear ";

    h = "cd ";
    uni = "cd /home/${user}/University/24-WiSe";
    root = "cd /";

    rkde = "kstart5 plasmashell";
    clean = "sudo nix-collect-garbage -v -d && sudo nix-store -v --gc && sudo nix-store -v --optimise";
    update = "sudo nix flake update --flake /home/${user}/nix-config";
    upgrade = "sudo nix flake update --flake /home/${user}/nix-config && sudo nixos-rebuild switch --flake /home/${user}/nix-config";
    upgrade-hs-here = "nixos-rebuild --target-host root@bvgcat.de switch --flake /home/${user}/nix-config#homeserver";
    upgrade-hs-there = "nixos-rebuild --build-host root@bvgcat.de --target-host root@bvgcat.de switch --flake /home/${user}/nix-config#homeserver";
  };
}
