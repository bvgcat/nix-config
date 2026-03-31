{
  config,
  pkgs,
  lib,
  hostname,
  user,
  ...
}:

{
  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = user;
      };
    };
  };
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};

  programs.waybar.enable = true;
  environment.systemPackages = with pkgs; [ alacritty fuzzel swaylock mako swayidle xwayland-satellite ];
}