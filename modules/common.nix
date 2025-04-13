{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.11> {};
in {
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
	
	imports = [
		#../nixos-tuberlin/BSPrak.nix
		#../nixos-tuberlin/SWTPP.nix
		./bash.nix
	];

	environment.systemPackages = with pkgs; [
		kdePackages.qtwebengine
		kdePackages.plasma-browser-integration
		kdePackages.partitionmanager
		kdePackages.kpmcore

		appimage-run
		baobab
		bear
		bootiso 
		brave
		clang-tools
		pkgs-24.ecryptfs
		gcc-arm-embedded
		glib
		glibc
		gnumake
		gnupg
		gparted
		iptsd
		nixfmt-rfc-style
		ntfs3g
		pkgs-24.scrounge-ntfs
		openocd
		pciutils
		pinentry-all
		powertop
		power-profiles-daemon
		savvycan
		qdirstat
		usbutils
		zsh
		
		#virtualisation
		libvirt
		qemu_full
		virt-manager
		OVMFFull

		direnv
		input-leap
		vscodium
	];

	users.users.h.packages = with pkgs; [
		kdePackages.kdenlive 
		anki
		ausweisapp
		blender
		brave
		can-utils
		discord
		disko
		doxygen_gui
		drawio
		element-desktop
		fastfetch
		firefox
		flatpak 
		freecad
		git
		imagemagick
		joplin-desktop
		kdePackages.kdenlive 
		keepassxc
		kicad
		libreoffice
		nextcloud-client
		nixd
		nixdoc
		nixos-anywhere
		nixpkgs-lint-community
		obsidian
		octaveFull
		qalculate-qt
		rnote
		rpi-imager
		signal-desktop-bin
		sops
		spotify  
		syncthing
		#teams-for-linux
		texliveFull
		tor-browser
		tree
		thunderbird
		ventoy-full
		vlc
		xournalpp
	];	
	
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


	# for partition-manager
	programs.partition-manager.enable = true;

	hardware.bluetooth.enable = true;
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
	# STLink v2
	services.udev.extraRules = 	
	''SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="0666"
		SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666"'';
}
