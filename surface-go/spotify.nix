{
  config,
  pkgs,
  lib,
  ...
}:

{
  systemd = {
    services = {
      kiosk-firefox = {
        description = "Firefox in kiosk mode";
        wantedBy = [ "graphical.target" ];
        after = [ "graphical.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.firefox}/bin/firefox -kiosk https://open.spotify.com/";
          Restart = "on-failure";
          RestartSec = 5;
          User = ""; # <- Change to your desired user
          Environment = [
            "MOZ_ENABLE_WAYLAND=1"
            "WAYLAND_DISPLAY=wayland-0"
            "XDG_RUNTIME_DIR=/run/user/1000" # ← very important
          ];
        };
      };
    };
  };
}
