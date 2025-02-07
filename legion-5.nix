{ config, lib, pkgs, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in {
  imports = [ 
		./modules/common.nix
		./modules/nvidia.nix
		./nixos-hardware/lenovo/legion/15arh05h/default.nix 
	];

	fileSystems."/run/media/h/windows" =
	{ device = "/dev/nvme0n1p3";
		fsType = "ntfs-3g"; 
		options = [ "rw" "uid=h"];
	};

	boot.kernelModules = [
    "snd_hda_intel"
		"nvidia"
		"nvidia_modeset"
		"nvidia_uvm"
		"nvidia_drm"
  ];

	#boot.kernelPackages = pkgs.linuxPackages_latest;
	services.displayManager.defaultSession = "plasma";

  environment.systemPackages = with pkgs; [
		kdePackages.qtwebengine
		kdePackages.plasma-browser-integration
		kdePackages.partitionmanager
		kdePackages.kpmcore
    
		clang-tools
		gcc-arm-embedded
		savvycan
		pkgs.stm32cubemx

		libvirt
		qemu_full
		virt-manager
		OVMFFull
	];

	users.users.h = {
		packages = with pkgs; [
			kicad
			pkgs-unstable.freecad
			pkgs-unstable.octaveFull
			tutanota-desktop
		];
	};

	# for partition-manager
	programs.partition-manager.enable = true;
	services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];

	# for virtualistion
	programs.virt-manager.enable = true;
	
	specialisation = {
		"VFIO".configuration = {
			system.nixos.tags = [ "with-vfio" ];
			vfio.enable = true;
			imports = [ ./modules/virtualisation.nix ];
		};
		#"cosmic".configuration = {
		#		system.nixos.tags = [ "cosmic" ];
		#		imports = [ ./nixos-cosmic/nixos/default.nix ];
		#};
	};

	users.users.h.extraGroups = [ "qemu-libvirtd" "libvirtd" "disk" ];
	virtualisation = with pkgs-unstable; {
		spiceUSBRedirection.enable = true;
		libvirtd = {
			enable = true;
			qemu = {
				runAsRoot = true;
				swtpm.enable = true;
				ovmf.enable = true;
			};
			onBoot = "ignore";
			onShutdown = "shutdown";
		};
	};

	swapDevices = [
    { device = "/swapfile"; size = 8*1024; }
  ];
}