{ config, lib, pkgs, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in
{
	imports = [
		./modules/common.nix
		./nixos-hardware/microsoft/surface/surface-go/default.nix # surface go hardware
	];
	
	boot.kernelModules = [ "snd_hda_intel" ];
	boot.supportedFilesystems = [ "ntfs" ];
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
			vpl-gpu-rt
    ];
  };
	environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

	environment.systemPackages = with pkgs; [];

	users.users.h.packages = with pkgs; [
		pkgs-24.kicad-small
		signal-desktop
	];

	swapDevices = [
    { device = "/swapfile"; size = 4*1024; }
  ];
}
