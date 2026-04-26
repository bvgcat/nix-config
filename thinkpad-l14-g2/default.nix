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
    (pkgs.callPackage ../modules/plecs.nix { })
    fprintd
    fprintd-tod
    libfprint-tod

    android-tools
    scrcpy

    bottles
    discord
    kicad
    libvirt
    nixos-anywhere
    freecad
    prismlauncher
    qemu
    signal-desktop
    spice-vdagent
    texliveFull
    virt-manager
    vscode
    OVMFFull
  ];
  
  users.users.${user} = {
    isNormalUser = true;
    description = "h";
    extraGroups = [
      "networkmanager"
      "wheel"
      "qemu-libvirtd"
      "libvirtd"
      "disk"
    ];
    packages = with pkgs; [
      tor-browser
    ];
  };

  networking = {
    hostName = hostname;
    wireguard.interfaces.wg0.privateKeyFile = "/home/${user}/Safe/wireguard/thinkpad-l14-g2.pub";
  };

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

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
    enableAllFirmware = true;
  };
  services = {
    thermald.enable = true;
    power-profiles-daemon = {
      enable = true;
      package = pkgs.power-profiles-daemon;
    };
  };

  # for virtualistion
  programs.virt-manager.enable = true;
  virtualisation = {
    waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
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

  systemd.user.services.input-leaps-autostart = {
    description = "Input Leap";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.input-leap}/bin/input-leaps -c .config/InputLeap/config.conf";
    };
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
