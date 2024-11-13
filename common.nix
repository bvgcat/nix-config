{ config, pkgs, lib, ... }:

let
	pkgs-unstable = import <nixos-unstable> {};
in {

	imports = [
		./nixos-tuberlin/BSPrak.nix
		./nixos-tuberlin/SWTPP.nix
		./modules/docker.nix
		./modules/bash.nix
	];

	environment.systemPackages = with pkgs; [
		appimage-run
		baobab
		bear
		bootiso
   	brave
		ecryptfs
		gnumake
		gparted
		iptsd
		ntfs3g
		scrounge-ntfs
		openocd
		#qdirstat
		usbutils
		zsh

		#vscodium
		direnv
		pkgs-unstable.input-leap
		vscodium
	];

	users.users.h.packages = with pkgs; [
		ausweisapp
		brave
		can-utils
		discord
		fastfetch
		firefox
		git
		pkgs-unstable.joplin-desktop
		keepassxc
		libreoffice
		nextcloud-client
		obsidian
		qalculate-gtk 
		pkgs-unstable.rnote
		rpi-imager
		signal-desktop
		spotify  
		syncthing
		teams-for-linux
		tor-browser
		tree
		thunderbird
		ventoy-full
		vlc
		xournalpp
	];	

	# for partition-manager
	programs.partition-manager.enable = true;
	services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];

	hardware.bluetooth.enable = true;
	services.xserver.excludePackages = [ pkgs.xterm ];
	boot.supportedFilesystems = [ "ntfs" ];

  # to enable kdeconnect
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

	services.avahi = {
		enable = true;
		nssmdns4 = true;
		openFirewall = true;
	};

	# STLink v3
	# STLink v2 or smth
	services.udev.extraRules = 	
	''SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="0666"
		SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666"'';
}