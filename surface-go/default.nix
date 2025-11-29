{
  config,
  pkgs,
  lib,
  hostname,
  user,
  ...
}:

{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  ### Packages
  environment.systemPackages = with pkgs; [
    maliit-keyboard
  ];

  users.users.${user}.packages = with pkgs; [
  ];

  boot.kernelPatches = [{
    name = "rust-1.91-fix";
    patch = ../hacks/rust-fix.patch;
  }];

  hardware.microsoft-surface.kernelVersion = "stable";
  
  networking.hostName = hostname; # Define your hostname.

  # luks keyboard layout
  console.keyMap = "gr";
  services.xserver = {
    enable = true;
    xkb = {
      layout = "gb";
      variant = "";
    };  
  };

  boot = {
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


  swapDevices = [
    {
      device = "/swapfile";
      size = 1024*4;
    }
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}