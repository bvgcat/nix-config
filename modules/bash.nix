{
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
    update = "sudo nix flake update --flake ./nix-config";
    upgrade = "sudo nixos-rebuild switch --flake ./nix-config";
    upgrade-git = "sudo nixos-rebuild switch --flake github:bvgcat/nix-config";
    upgrade-me = "sudo nixos-rebuild switch --flake ./nix-config";
    upgrade-hs = "nixos-rebuild --target-host root@192.168.0.110 switch --flake github:bvgcat/nix-config";
    upgrade-pi = "nixos-rebuild --target-host root@192.168.0.100 switch --flake github:bvgcat/nix-config";
    upgrade-sg = "nixos-rebuild --target-host root@192.168.0.229 switch --flake github:bvgcat/nix-config";
  };
}
