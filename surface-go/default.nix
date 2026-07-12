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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AlwaysPairable = true;
        IdleTimeout = 0;
        Experimental = true;
        FastConnectable = true;
        JustWorksRepairing = true;
      };
      Policy = {
        AutoEnable = true;
        ResumeDelay = 5;
      };
    };
  };

  services.pipewire.extraConfig.pipewire."99-bluetooth-buffer" = {
    "context.properties" = {
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 1024;
      "default.clock.max-quantum" = 2048;
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0cf3", ATTR{idProduct}=="e302", TEST=="power/control", ATTR{power/control}="on"
  '';
  environment.systemPackages = with pkgs; [
    librespot
    maliit-keyboard
  ];

  users.users.${user}.packages = with pkgs; [
  ];
  
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