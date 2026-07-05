{
  user,
  ...
}:

{
  programs.bash.shellAliases = {
    q = "exit ";
    c = "clear ";

    h = "cd ";
    root = "cd /";

    rkde = "kstart5 plasmashell";
    clean = "sudo nix-collect-garbage -v -d && sudo nix-store -v --gc && sudo nix-store -v --optimise";
    update = "sudo nix flake update --flake ./nix-config";
    upgrade = "sudo nixos-rebuild switch --flake ./nix-config";
    upgrade-git = "sudo nixos-rebuild switch --flake github:bvgcat/nix-config";
    upgrade-me = "sudo nixos-rebuild switch --build-host builder@192.168.0.110 --flake ./nix-config";
    upgrade-hs = "nixos-rebuild --target-host builder@192.168.0.110 switch --flake github:bvgcat/nix-config#homeserver";
    upgrade-pi = "nixos-rebuild --target-host builder@192.168.0.100 switch --flake github:bvgcat/nix-config#pi3b";
    upgrade-sg = "nixos-rebuild --target-host builder@192.168.0.229 switch --flake github:bvgcat/nix-config#surface-go";
  };
}
