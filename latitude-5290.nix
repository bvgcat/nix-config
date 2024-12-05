{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in {

  	imports = [
		./modules/common.nix
		#./nixos-hardware/microsoft/surface/surface-go/default.nix # surface go hardware
	];

    boot.supportedFilesystems = [ "ntfs" ];
	hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [];

	users.users.h.packages = with pkgs; [
		kicad
		signal-desktop
	];

    swapDevices = [ { device = "/swapfile"; size = 8128; } ];
}

