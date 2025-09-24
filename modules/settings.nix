{
  config,
  pkgs,
  lib,
  user,
  ...
}:


let 
  pwd = "$y$j9T$H801xAtifzZymLFhYfTPE.$OyXSj2K8JCGGwkvDEFuAV0KhW7Gn59uobxBLDxFuK/4";
in {
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

  services.cloudflare-warp = {
    enable = true;
    package = pkgs.cloudflare-warp;
    openFirewall = true;
  };

  services.openssh.enable = true;
  time.timeZone = "Europe/Berlin";
  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
    };
  };
  
  hardware.bluetooth.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];

  services.printing.enable = true;

  programs.firefox.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  # optimises the nix store
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
    extraOptions = ''
      secret-key-files = /etc/nix/homeserver
    '';

    optimise = {
      automatic = true;
      dates = [ "weekly" ]; # optimise periodically
    };
    gc = {
      automatic = true;
      dates = "weekly";
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

  # STLink v3
  # STLink v2
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666"'';
}
