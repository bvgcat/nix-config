{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in {
  imports = [
		./modules/common.nix
		./nixos-hardware/dell/latitude/7280/default.nix # surface go hardware
	];

	### Hardware

	boot = {
		## to detect windows
		kernelParams = [ "mem_sleep_default=deep" ];
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
		auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
	};

	### Packages
  environment.systemPackages = with pkgs; [];

	users.users.h.packages = with pkgs; [
		pkgs-unstable.freecad
		kicad
		pkgs-unstable.octaveFull
	];

	#systemd.services.fprintd = {
	#	wantedBy = [ "multi-user.target" ];
	#	serviceConfig.Type = "simple";
	#};

	#services.fprintd = {
	#	enable = true;
 	#	tod.enable = true;
	#	tod.driver = pkgs-unstable.libfprint-2-tod1-broadcom;
	#};
  swapDevices = [ { device = "/swapfile"; size = 8128; } ];
}

