{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  fileSystems."/run/media/h/windows" = {
    device = "/dev/nvme0n1p3";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=h"
    ];
  };

  boot.kernelModules = [
    "snd_hda_intel"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  # for virtualistion
  programs.virt-manager.enable = true;

  specialisation = {
    "VFIO".configuration = {
      system.nixos.tags = [ "with-vfio" ];
      vfio.enable = true;
      imports = [ ./modules/virtualisation.nix ];
    };
    "cosmic".configuration = {
      services.desktopManager.cosmic.enable = true;
      services.displayManager.cosmic-greeter.enable = true;

      services.displayManager.sddm.enable = lib.mkForce false;
      services.desktopManager.plasma6.enable = lib.mkForce false;
    };
  };

  virtualisation = with pkgs; {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
        ovmf.enable = true;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  networking.hostName = "legion-5"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
  };

  console.keyMap = "de";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  system.stateVersion = "23.11"; # Did you read the comment?
}
