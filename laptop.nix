{ config, lib, pkgs, ... }:

{
  imports = [ 
		./nvidia.nix
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
    
		looking-glass-client
		qemu_full
    virt-manager
		savvycan
	];
	
	# for partition-manager
	programs.partition-manager.enable = true;
	services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];

	# for virtualistion
	programs.virt-manager.enable = true;
	specialisation."VFIO".configuration = {
		system.nixos.tags = [ "with-vfio" ];
		vfio.enable = true;
		imports = [ ./virtualisation.nix ];
	};

	users.users.h = {
		packages = with pkgs; [
			android-tools
			lshw
			ffmpeg-full
			pciutils
			tor-browser
			tutanota-desktop
		];
	};
  
	swapDevices = [
    { device = "/swapfile"; size = 16*1024; } # higher priority -> prefer this. priority = 10;
    #{ device = "/run/media/h/sdcard/swapfile"; size = 8*1000; priority = 0;}
  ];
}