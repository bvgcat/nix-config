{
  nixpkgs-old,
  pkgs,
  user,
  ...
}:

let
  oldPkgs = nixpkgs-old.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../modules/plecs.nix { })
    fprintd
    fprintd-tod
    libfprint-tod

    kdePackages.kdenlive
    kdePackages.kpmcore
    kdePackages.plasma-browser-integration
    kdePackages.partitionmanager
    kdePackages.qtwebengine
    kdePackages.wacomtablet
    
    android-tools
    scrcpy

    brave
    discord
    gearlever
    element-desktop
    (pkgs.ffmpeg-full.override { withUnfree = true; })
    oldPkgs.kicad
    libreoffice
    libvirt
    nextcloud-client
    nixos-anywhere
    freecad
    prismlauncher
    qemu
    signal-desktop
    spice-vdagent
    texliveFull
    thunderbird
    virt-manager
    vscode
    vscodium
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

  programs = {
    partition-manager.enable = true;
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
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
  services.spice-vdagentd.enable = true;  # enable copy and paste
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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix.settings.extra-platforms = [
    "aarch64-linux"
  ];

  systemd.user.services.input-leaps-autostart = {
    description = "Input Leap server";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "network-online.target" ];
    after = [
      "graphical-session.target"
      "network-online.target"
    ];

    serviceConfig = {
      ExecStart =
        "${pkgs.input-leap}/bin/input-leaps -c /home/${user}/.config/InputLeap/config.conf --no-daemon";
      Restart = "always";
      RestartSec = 10;
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
