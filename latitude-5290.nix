{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in {

	
  imports = [
		./modules/common.nix
		./nixos-hardware/dell/latitude/7280/default.nix # surface go hardware
	];

	boot.kernelModules = [ "snd_hda_intel" ];
  boot.supportedFilesystems = [ "ntfs" ];
	hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [];

	users.users.h.packages = with pkgs; [
		pkgs-unstable.freecad
		kicad
		pkgs-unstable.octaveFull
		signal-desktop
	];

    swapDevices = [ { device = "/swapfile"; size = 8128; } ];
}

