{
  config,
  pkgs,
  lib,
  hostname,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = hostname; # Define your hostname.

  # luks keyboard layout
  console.keyMap = "de";
  services.xserver = {
    enable = true;
    xkb.layout = "de";
  };

  boot = {
    kernelParams = [
      "mem_sleep_default=s2idle"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "snd_hda_intel" ];
    supportedFilesystems = [ "ntfs" ];
  };

  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt # for newer GPUs on NixOS <= 24.05
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
    maliit-keyboard
  ];

  users.users.h = {
    isNormalUser = true;
    description = "h";
    extraGroups = [
      "networkmanager"
      "wheel"
      "disk"
    ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8128;
    }
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}