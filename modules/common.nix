{
  config,
  pkgs,
  lib,
  ...
}:

{
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
    gcc-arm-embedded
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

    #virtualisation
    libvirt
    qemu
    spice-vdagent
    virt-manager
    OVMFFull

    direnv
    vscodium
  ];

  users.users.h.packages = with pkgs; [
    kdePackages.kdenlive
    ausweisapp
    brave
    deluge
    can-utils
    discord
    disko
    drawio
    #element-desktop
    fastfetch
    firefox
    # With this
    (wrapFirefox (firefox-unwrapped.override { pipewireSupport = true; }) { })
    flatpak
    git
    #imagemagick
    kdePackages.kdenlive
    keepassxc
    #kicad
    libreoffice
    marksman
    nextcloud-client
    nixd
    nixdoc
    nixfmt-rfc-style
    nixos-anywhere
    obsidian
    python3Minimal
    qalculate-qt
    rnote
    sops
    spotify
    syncthing
    texliveMinimal
    tor-browser
    thunderbird
    ventoy-full
    vlc
  ];

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
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

  # for partition-manager
  programs.partition-manager.enable = true;

  # to enable kdeconnect
  programs.kdeconnect.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # make systemd service start automatically
  services.syncthing = {
    enable = true;
    configDir = "/home/h/.config/syncthing";
    user = "h";
  };
  networking.firewall.allowedTCPPorts = [
    8384
    22000
    24800
  ];
  networking.firewall.allowedUDPPorts = [
    21027
    22000
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
