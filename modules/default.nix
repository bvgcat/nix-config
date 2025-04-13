{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.11> {};
in {
  imports = [
    ./bash.nix 
    ./common.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

	services.flatpak.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	xdg.portal.config.common.default = "gtk";

	boot.loader= {
		systemd-boot.enable = true;
		efi = {
			canTouchEfiVariables = true;
		};
	};

	hardware.bluetooth.enable = true;
	boot.supportedFilesystems = [ "ntfs" ];

	# optimises the nix store
	nix.optimise = {
		automatic = true;
		dates = [ "weekly" ]; # optimise periodically
	};

	# automation of garbage collection
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};


	i18n.extraLocaleSettings = {
		LC_ALL = "en_US.UTF-8";
		LC_CTYPE = "de_DE.UTF-8";
		LC_ADDRESS = "de_DE.UTF-8";
		LC_IDENTIFICATION = "de_DE.UTF-8";
		LC_MEASUREMENT = "de_DE.UTF-8";
		LC_MESSAGES = "de_DE.UTF-8";
		LC_MONETARY = "de_DE.UTF-8";
		LC_NAME = "de_DE.UTF-8";
		LC_NUMERIC = "de_DE.UTF-8";
		LC_PAPER = "de_DE.UTF-8";
		LC_TELEPHONE = "de_DE.UTF-8";
		LC_TIME = "de_DE.UTF-8";
		LC_COLLATE = "de_DE.UTF-8";
	};

	# STLink v3
	# STLink v2
	services.udev.extraRules = 	
	''SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="0666"
		SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666"'';
}