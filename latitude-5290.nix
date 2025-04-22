{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.11> {};
in {
  imports = [
		./modules/default.nix
		<nixos-hardware/dell/latitude/5490> # surface go hardware
	];

	networking.hostName = "latitude-5290"; # Define your hostname.
	services.xserver.enable = true;

	boot = {
		kernelParams = [ "mem_sleep_default=deep" "acpi_enforce_resources=lax" "i915.enable_dc=0" ];
		kernelPackages = pkgs.linuxPackages_latest;
		kernelModules = [ "snd_hda_intel" ];
		supportedFilesystems = [ "ntfs" ];
	};
		
	hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
	hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt  				# for newer GPUs on NixOS <= 24.05
    ];
  };
	services = {
    thermald.enable = true;
    power-profiles-daemon = {
			enable = true;
			package = pkgs.power-profiles-daemon;
		};
	};

	### Packages
  environment.systemPackages = with pkgs; [
	#	fprintd
	#	fprintd-tod
	#	libfprint-tod
	#	libfprint-2-tod1-broadcom
		maliit-keyboard
	];

	users.users.h = {
    isNormalUser = true;
    description = "h";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

	#services.fwupd.enable = true;
	#systemd.services.fprintd = {
	#	wantedBy = [ "multi-user.target" ];
	#	serviceConfig.Type = "simple";
	#};

	#services.fprintd = {
	#	enable = true;
 	#	tod.enable = true;
	#	tod.driver = pkgs.libfprint-2-tod1-broadcom;
	#};
  swapDevices = [ { device = "/swapfile"; size = 8128; } ];

	system.stateVersion = "24.05"; # Did you read the comment?

}

