{ config, lib, pkgs, ... }:

{
  imports = [ 
		./common.nix
		./modules/nvidia.nix
		./nixos-hardware/lenovo/legion/15arh05h/default.nix 
	];

	fileSystems."/run/media/h/windows" =
	{ device = "/dev/nvme0n1p3";
		fsType = "ntfs-3g"; 
		options = [ "rw" "uid=h"];
	};
	
	#boot.kernelPackages = pkgs.linuxPackages_latest;
	services.displayManager.defaultSession = "plasma";
	
  environment.systemPackages = with pkgs; [
		kdePackages.qtwebengine
		kdePackages.plasma-browser-integration
		kdePackages.partitionmanager
		kdePackages.kpmcore
    
		clang-tools_18
		gcc-arm-embedded-13
		savvycan
		stm32cubemx

		looking-glass-client
		qemu_full
    virt-manager
	];

	users.users.h = {
		packages = with pkgs; [
			android-tools
			kicad
			lshw
			ffmpeg-full
			pciutils
			tor-browser
			tutanota-desktop
		];
	};

	# for partition-manager
	programs.partition-manager.enable = true;
	services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];

	# for virtualistion
	programs.virt-manager.enable = true;
	specialisation."VFIO".configuration = {
		system.nixos.tags = [ "with-vfio" ];
		vfio.enable = true;
		imports = [ ./modules/virtualisation.nix ];
	};
  
	swapDevices = [
    { device = "/swapfile"; size = 16*1024; }
  ];
}