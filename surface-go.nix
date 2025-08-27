{
  modulesPath,
  config,
  lib,
  pkgs,
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
    gparted
    input-leap
    openssl
    qdirstat
  ];
  programs.kdeconnect.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  system.stateVersion = "24.11";
}
