{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ./disk-config.nix
    ./part-db.nix
    ../modules/bash.nix
    #./nextcloud.nix
    #"${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/microsoft/surface/surface-go"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services = {
    #xserver.enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
  ];
  
  services.openssh.enable = true;
  users.users = {
    root.openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
    ];
  };

	boot.kernelModules = [ "snd_hda_intel" ];
	hardware.bluetooth.enable = true;
  networking.hostName = "surface-go"; # Define your hostname.

	swapDevices = [
    { device = "/swapfile"; size = 4*1024; }
  ];

  system.stateVersion = "24.11";
}
