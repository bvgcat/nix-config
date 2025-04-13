{ config, pkgs, lib, ... }:

{

  programs.bash = { 
    #shellInit = {
    #  "export PATH=$HOME/arm/bin:$PATH"
    #  "export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
    #};
    
    shellAliases = {
      q = "exit ";
      c = "clear ";

      h = "cd ";
      uni = "cd /home/h/University/24-WiSe";
      root = "cd /";

      rkde = "kstart5 plasmashell";
      clean = "sudo nix-collect-garbage -v -d && sudo nix-store -v --gc && sudo nix-store -v --optimise";
      update = "sudo nixos-rebuild switch -v ";
      updatefast = "sudo nixos-rebuild switch --fast -v";
      upgrade = "sudo nixos-rebuild switch --upgrade-all -v";
      upgradesurface = "nixos-rebuild --target-host root@192.168.0.200 switch --flake /home/h/nix-config/surface-go";
    };
  };
}