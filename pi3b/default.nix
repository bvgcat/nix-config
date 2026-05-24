{
  pkgs,
  user,
  hostname,
  ...
}:
let 
  pwd = "$y$j9T$H801xAtifzZymLFhYfTPE.$OyXSj2K8JCGGwkvDEFuAV0KhW7Gn59uobxBLDxFuK/4";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    openssl
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
  users.users = {
    root = {
      hashedPassword = pwd;
    };
    ${user} = {
      isNormalUser = true;
      group = "users";
      hashedPassword = pwd;
      extraGroups = [
        "networkmanager"
        "wheel"
        "disk"
      ]; 
    };
  };
  
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  networking.hostName = hostname;
  boot.kernelParams = [
    "console=ttyAMA0,115200"
    "console=tty1"
  ];

  system.autoUpgrade = {
    enable = true;
    operation = "switch";
    flake = "github:bvgcat/nix-config";
    dates = "Sat *-*-* 2:00:00";
  };

  security.rtkit.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  programs.kdeconnect.enable = true;

  users.groups.services = {};

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [
        "homeserver:21gbBImd72iH+aKAxOXZXzj8fkTGrMtlxiL4SSzHgoY="
      ];
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ]; # optimise periodically
    };
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 7d";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";  # base locale (for LANG)
  i18n.extraLocaleSettings = {
    LC_CTYPE = "de_DE.UTF-8";
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";  # Keep messages in English
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
    LC_COLLATE = "de_DE.UTF-8";
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}