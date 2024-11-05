{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in {

  programs.bash = { 
    #shellInit = {
    #  "export PATH=$HOME/arm/bin:$PATH"
    #  "export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
    #};
    
    shellAliases = {
      q = "exit ";
      c = "clear ";

      h = "cd ";
      root = "cd /";

      clean = "sudo nix-store -v --optimise && sudo nix-store -v --gc && sudo nix-collect-garbage -v -d ";
      update = "sudo nixos-rebuild switch -v ";
      updatefast = "sudo nixos-rebuild switch --fast -v";
      upgrade = "sudo nixos-rebuild switch --upgrade-all -v";
    };
  };
}