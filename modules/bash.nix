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
    upgrade-git = "sudo nixos-rebuild switch --refresh --flake github:bvgcat/nix-config";
    upgrade-me = "sudo nixos-rebuild switch --build-host builder@homeserver --flake github:bvgcat/nix-config";
    upgrade-pi = "nixos-rebuild --build-host builder@homeserver --target-host root@pi3b switch --flake github:bvgcat/nix-config#pi3b";
    upgrade-hs = "nixos-rebuild --build-host builder@homeserver --target-host root@homeserver switch --flake github:bvgcat/nix-config#homeserver";
    upgrade-sg = "nixos-rebuild --build-host builder@homeserver --target-host root@surface-go switch --flake github:bvgcat/nix-config#surface-go";
    upgrade-all = "upgrade-hs && upgrade-me && upgrade-pi && upgrade-sg";
  };
}
