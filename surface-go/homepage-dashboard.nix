{
  config,
  pkgs,
  lib,
  ...
}:

let
  port = 8080;
  portstr = toString port;
in
{
  services.homepage-dashboard = {

    # These options were already present in my configuration.
    enable = true;

    # The following options were what I planned to add.
    # https://gethomepage.dev/latest/configs/settings/
    settings = { };

    # https://gethomepage.dev/latest/configs/bookmarks/
    bookmarks = [ ];

    # https://gethomepage.dev/latest/configs/services/
    services = [ ];

    # https://gethomepage.dev/latest/configs/service-widgets/
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
    ];

    # https://gethomepage.dev/latest/configs/kubernetes/
    kubernetes = { };

    # https://gethomepage.dev/latest/configs/docker/
    docker = { };

    # https://gethomepage.dev/latest/configs/custom-css-js/

    customJS = "";
    customCSS = "";
  };

  systemd = {
    services = {
      NetworkManager = {
        wantedBy = [ "multi-user.target" ];
      };
      suspend = {
        enable = false;
      };
      open-homepage = {
        description = "Homepage Dashboard";
        wantedBy = [ "graphical.target" ];
        after = [ "graphical.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.firefox}/bin/firefox -kiosk http://localhost:${portstr}";
          Restart = "on-failure";
          RestartSec = 5;
          User = "homeserver";
          Environment = [
            "MOZ_ENABLE_WAYLAND=1"
            "WAYLAND_DISPLAY=wayland-0"
            "XDG_RUNTIME_DIR=/run/user/1001" # ← very important
          ];
        };
      };
    };
  };
}
