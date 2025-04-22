{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ./disk-config.nix
    ./part-db.nix
    ../modules/bash.nix
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
    displayManager = {
      sddm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "partdb-terminal";
    };
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

	boot.loader= {
		systemd-boot.enable = true;
		efi = {
			canTouchEfiVariables = true;
		};
	};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  systemd.services.suspend = {
    enable = false;
  };

  services.openssh.enable = true;
  boot.initrd.network.ssh.enable = true;
  systemd.services.NetworkManager = {
    wantedBy = [ "multi-user.target" ];
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
    ];
    partdb-terminal = {
      isNormalUser = true;
      group = "users";
      password = "";
      openssh.authorizedKeys.keys = [
        # change this to your ssh key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    php
	];

	boot.kernelModules = [ "snd_hda_intel" ];
	hardware.bluetooth.enable = true;
  networking.hostName = "partdb-terminal"; # Define your hostname.

	swapDevices = [
    { device = "/swapfile"; size = 4*1024; }
  ];

  system.stateVersion = "24.11";
}
