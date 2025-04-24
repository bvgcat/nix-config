{ config, pkgs, lib, ... }:

{
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
		#pkgs-24.ecryptfs
		#gcc-arm-embedded
		glib
		glibc
		gnumake
		
		gnupg
		gparted
		#input-leap
		iptsd
		nixfmt-rfc-style
		ntfs3g
		#pkgs-24.scrounge-ntfs
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
		# With this
		(wrapFirefox (firefox-unwrapped.override { pipewireSupport = true;}) {})
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
		pinentry-all
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
	
	programs.firefox = {
		enable = true;
		preferences = {
			"widget.use-xdg-desktop-portal.file-picker" = 1;
		};
	};
	environment.sessionVariables = {
		MOZ_USE_XINPUT2 = "1";
	};
	xdg = {
		portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-wlr
				xdg-desktop-portal-gtk
			];
		};
	};

	# for partition-manager
	programs.partition-manager.enable = true;

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

	services.avahi = {
		enable = true;
		nssmdns4 = true;
		openFirewall = true;
	};
}
