{
  modulesPath,
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  hostname = "homeserver";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./deluge.nix
    ./disk-config.nix
    ./hardware-configuration.nix
    ./homepage-dashboard.nix
    ./immich.nix
    ./networking.nix
    ./nextcloud.nix
    ./nginx.nix
    ./restic.nix
    ./spotify.nix
    ./ssh.nix
    ./thelounge.nix
  ];

  system.autoUpgrade = {
    enable = true;
    operation = "switch";
    flake = "/home/${user}/nix-config";
    upgrade = true;
    dates = "04:00";
    allowReboot = true;
    rebootWindow = { lower = "02:00"; upper = "06:00"; };
  };

  # Configure keymap in X11
  security.rtkit.enable = true;
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      autoLogin.enable = true;
      sddm.autoLogin.relogin = true;
      autoLogin.user = "${hostname}";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    logind.settings.Login = {
      HandleLidSwitch = "lock";
      HandleLidSwitchDocked = "lock";
      HandleLidSwitchExternalPower = "lock";
    };
    xserver.xkb = {
      layout = "gb";
      variant = "";
    };
  };
  
  systemd = {
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Optionally, set the environment variable
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-browser-integration
    certbot-full
    curl
    git
    gnome-network-displays
    gparted
    input-leap
    openssl
    qdirstat
    vlc
  ];
  programs.kdeconnect.enable = true;

  users.groups.services = {};

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  system.stateVersion = "25.05";
}
