{
  config,
  pkgs,
  lib,
  ...
}:

{
  services = {
    homepage-dashboard = {
      enable = true;
      listenPort = 8080;
      allowedHosts = "";
      openFirewall = false;
      bookmarks = [ ];
      widgets = [
        {
          resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
        }
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];
      settings = { }; # see https://gethomepage.dev/configs/settings/
      services = [ ]; # see https://gethomepage.dev/configs/services/
    };
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
        description = "Firefox in kiosk mode";
        wantedBy = [ "graphical.target" ];
        after = [ "graphical.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.firefox}/bin/firefox -kiosk http://localhost:8080";
          Restart = "on-failure";
          RestartSec = 5;
          User = "partdb-terminal"; # <- Change to your desired user
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
