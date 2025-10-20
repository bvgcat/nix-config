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
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./plecs.nix { })
    fprintd
    fprintd-tod
    libfprint-tod

    #virtualisation
    libvirt
    qemu
    spice-vdagent
    virt-manager
    OVMFFull
  ];

  users.users.${user}.packages = with pkgs; [
    bottles
  ];

  networking.hostName = hostname; # Define your hostname.

  # luks keyboard layout
  console.keyMap = "de";
  services.xserver = {
    enable = true;
    xkb.layout = "de";
  };

  boot = {
    kernelParams = [];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [];
    supportedFilesystems = [ "ntfs" ];
  };

  fileSystems."/run/media/h/windows" = {
    device = "/dev/nvme0n1p3";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=h"
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
  hardware.graphics = {
    enable = true;
  };
  services = {
    thermald.enable = true;
    power-profiles-daemon = {
      enable = true;
      package = pkgs.power-profiles-daemon;
    };
  };

  users.users.h = {
    isNormalUser = true;
    description = "h";
    extraGroups = [
      "networkmanager"
      "wheel"
      "qemu-libvirtd"
      "libvirtd"
      "disk"
    ];
  };

  # for virtualistion
  programs.virt-manager.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

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
  swapDevices = [
    {
      device = "/swapfile";
      size = 8128;
    }
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
