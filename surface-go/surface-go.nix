{ config, lib, pkgs, ... }:

let
	pkgs-24 = import <nixos-24.11> {};
in
{
	imports = [
		#./modules/common.nix
		./nixos-hardware/microsoft/surface/surface-go/default.nix # surface go hardware
    ./disk-config.nix
	];
	
	boot.kernelModules = [ "snd_hda_intel" ];
	boot.supportedFilesystems = [ "ntfs" ];
	services.openssh.enable = true;
	boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
	hardware.bluetooth.enable = true;

	nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.opengl = { # hardware.graphics on unstable
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
	  #vpl-gpu-rt
    ];
  };
	environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
  ];
	
	users.users.h.packages = with pkgs; [
		pkgs-24.kicad-small
	];

	swapDevices = [
    { device = "/swapfile"; size = 4*1024; }
  ];
}
