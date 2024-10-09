{ config, lib, pkgs, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in
{
	imports = [
		./common.nix
		./nixos-hardware/microsoft/surface/surface-go/default.nix # surface go hardware
	];

	boot.supportedFilesystems = [ "ntfs" ];
	hardware.bluetooth.enable = true;

	environment.systemPackages = with pkgs; [
		#for xournalpp
		binutils
		gnome.adwaita-icon-theme
	];

	users.users.h.packages = with pkgs; [
		pkgs-24.kicad-small
		pkgs-24.signal-desktop
	];

	swapDevices = [
    { device = "/swapfile"; size = 4*1024; }
  ];
}
