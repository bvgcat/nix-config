{ config, lib, pkgs, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in
{
	imports = [
    ./nixos-hardware/microsoft/surface/surface-go/default.nix # surface go hardware
	];

	boot.supportedFilesystems = [ "ntfs" ];
	hardware.bluetooth.enable = true;

	environment.systemPackages = with pkgs; [
		#xournal
		binutils
		brave
		gnome.adwaita-icon-theme

		appimage-run
		ecryptfs
		git
		gparted
		ntfs3g
		scrounge-ntfs
		usbutils
		vscodium
		zsh
	];

	users.users.h.packages = with pkgs; [
		firefox
		libreoffice
		pkgs-24.kicad-small
		qalculate-gtk
		pkgs-24.signal-desktop
		spotify 
		syncthing
		teams-for-linux
		thunderbird
		vlc
		xournalpp
	];

	programs.kdeconnect.enable = true;
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};

	# make systemd service start automatically
	services.syncthing = {
		enable = true;
		configDir = "/home/h/.config/syncthing";
		user = "h";
	};
	networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 22000 ];

  # optimises the nix store
  #nix.settings.auto-optimise-store = false; # optimise on build (slow)
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

	swapDevices = [ 
    { device = "/swapfile"; size = 8*1024;} 
  ];
  #boot.cleanTmpDir = true;

	# for partition-manager
	programs.partition-manager.enable = true;
	services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];

	# STLink v3
	# STLink v2 or smth
	services.udev.extraRules = 	
	''SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="0666"
		SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666"'';
}
