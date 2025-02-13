{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.11> {};
in {
  imports = [
		./modules/common.nix
		./nixos-hardware/dell/latitude/7280/default.nix # surface go hardware
	];

	### Hardware

	boot = {
		## to detect windows
		kernelParams = [ "mem_sleep_default=s2idle" "acpi_enforce_resources=lax" "i915.enable_dc=0" ];
		kernelPackages = pkgs.linuxPackages_latest;
		kernelModules = [ "snd_hda_intel" ];
		supportedFilesystems = [ "ntfs" ];
	};
		
	hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
	hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
			intel-media-driver # LIBVA_DRIVER_NAME=iHD
      onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
    ];
  };
	environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

	services = {
    thermald.enable = true;
    power-profiles-daemon = {
			enable = true;
			package = pkgs.power-profiles-daemon;
		};
	};

	### Packages
  environment.systemPackages = with pkgs; [
		fprintd
		fprintd-tod
		libfprint-tod
		libfprint-2-tod1-broadcom
		maliit-keyboard
	];

	users.users.h.packages = with pkgs; [
		freecad
		kicad
		octaveFull
	];

	services.fwupd.enable = true;
	systemd.services.fprintd = {
		wantedBy = [ "multi-user.target" ];
		serviceConfig.Type = "simple";
	};

	services.fprintd = {
		enable = true;
 		tod.enable = true;
		tod.driver = pkgs.libfprint-2-tod1-broadcom;
	};
  swapDevices = [ { device = "/swapfile"; size = 8128; } ];
}

