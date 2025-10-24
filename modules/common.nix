{
  config,
  pkgs,
  lib,
  user,
  ...
}:

{
  imports = [
    ./codium.nix
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.qtwebengine
    kdePackages.plasma-browser-integration
    kdePackages.partitionmanager
    kdePackages.kpmcore

    age
    appimage-run
    baobab
    bear
    bootiso
    brave
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
    zsh

    vscodium
  ];

  users.users.${user}.packages = with pkgs; [
    kdePackages.kdenlive
    brave
    deluge
    can-utils
    discord
    disko
    drawio
    #element-desktop
    fastfetch
    # With this
    (wrapFirefox (firefox-unwrapped.override { pipewireSupport = true; }) { })
    flatpak
    git
    kdePackages.kdenlive
    keepassxc
    kicad
    libreoffice
    marksman
    nextcloud-client
    nixd
    nixdoc
    nixos-anywhere
    obsidian
    qalculate-qt
    rnote
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
