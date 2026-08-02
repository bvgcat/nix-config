{
  pkgs,
  user,
  ...
}:

{
  imports = [
    ./codium.nix
  ];

  environment.systemPackages = with pkgs; [
    age
    clang-tools
    gnumake
    gparted
    input-leap
    openocd
    power-profiles-daemon
    zsh
  ];

  users.users.${user}.packages = with pkgs; [
    #drawio
    (wrapFirefox (firefox-unwrapped.override { pipewireSupport = true; }) { })
    qalculate-qt
    tidal-hifi
    vlc
    wireguard-tools
  ];

  programs = {
    firefox = {
      enable = true;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
    kdeconnect.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
    };
  };
}
