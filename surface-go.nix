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
  ];

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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
    ];
  };

  users.groups.services = {};

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
  ];
  programs.kdeconnect.enable = true;

  # Run chown recursively after mount to enforce ownership
  systemd.services.chown-sdcard = {
    description = "Fix sdcard and Immich perms";
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "
        # set proper permissions for the SD card
        ${pkgs.coreutils}/bin/chown -R :services /run/media/${user}/sdcard

        # ensure immich subdir exists and is owned by immich
        ${pkgs.coreutils}/bin/mkdir -p /run/media/${user}/sdcard/immich
        ${pkgs.coreutils}/bin/chown -R immich:immich /run/media/${user}/sdcard/immich
      ";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  system.stateVersion = "24.11";
}
