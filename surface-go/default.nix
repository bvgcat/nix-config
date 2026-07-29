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
    ./audio.nix
    ./disk-config.nix
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-bigscreen
    librespot
    maliit-keyboard
  ];

  users.users.${user}.packages = with pkgs; [
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AlwaysPairable = true;
        IdleTimeout = 0;
        Experimental = true;
        FastConnectable = true;
        DiscoverableTimeout = 0;
        PairableTimeout = 0;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

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