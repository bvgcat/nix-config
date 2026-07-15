{
  modulesPath,
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
    ./buildmachine.nix
    #./deluge.nix
    ./disk-config.nix
    ./hardware-configuration.nix
    ./home-assistant.nix
    ./homepage-dashboard.nix
    ./immich.nix
    ./mc-server.nix
    ./networking.nix
    ./nextcloud.nix
    ./nginx.nix
    #./restic.nix
    ./secrets.nix
    #./spotify.nix
    ./thelounge.nix
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.krdc        ## kdeconnect virtual display
    kdePackages.plasma-browser-integration
    #certbot-full
    curl
    git
    gnome-network-displays
    gparted
    input-leap
    openssl
    qdirstat
    vlc
  ];
  
  systemd.user.services.input-leapc-autostart = {
    description = "Input Leap client";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "network-online.target" ];
    after = [
      "graphical-session.target"
      "network-online.target"
    ];

    serviceConfig = {
      ExecStart =
        "${pkgs.input-leap}/bin/input-leapc -c /home/${user}/.config/InputLeap/config.conf --no-daemon thinkpad-l14-g2";
      Restart = "always";
      RestartSec = 10;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [
    "aarch64-linux"
  ];
  
  system.autoUpgrade = {
    enable = true;
    operation = "switch";
    flake = "github:bvgcat/nix-config";
    dates = "Sat *-*-* 4:00:00";
  };

  # Configure keymap in X11
  security.rtkit.enable = true;
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      sddm.autoLogin.relogin = true;
      autoLogin.enable = true;
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
      layout = "de";
      variant = "";
    };
  };
  
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Optionally, set the environment variable
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  programs.kdeconnect.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  system.stateVersion = "25.05";
}
