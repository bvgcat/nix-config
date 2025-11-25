{
  config,
  pkgs,
  lib,
  user,
  stable,
  ...
}:

{
  imports = [
    ./codium.nix
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.kdenlive
    kdePackages.krfb        ## kdeconnect virtual display
    kdePackages.kpmcore
    kdePackages.qtwebengine
    kdePackages.plasma-browser-integration
    kdePackages.partitionmanager

    age
    appimage-run
    clang-tools
    ecryptfs
    gnumake
    gnupg
    gparted
    input-leap
    iptsd
    ntfs3g
    openocd
    pciutils
    power-profiles-daemon
    savvycan
    sops
    qdirstat
    usbutils
    vscodium
    zsh
  ];

  users.users.${user}.packages = with pkgs; [
    brave
    can-utils
    disko
    drawio
    #element-desktop
    # With this
    (wrapFirefox (firefox-unwrapped.override { pipewireSupport = true; }) { })
    flatpak
    git
    keepassxc
    libreoffice
    marksman
    nextcloud-client
    nixd
    obsidian
    qalculate-qt
    stable.rnote
    syncthing
    tidal-hifi
    tor-browser
    thunderbird
    ventoy-full
    vlc
  ];

  programs = {
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    firefox = {
      enable = true;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
    partition-manager.enable = true;
    kdeconnect.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
    };
  };

  # Firefox
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.07"
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
