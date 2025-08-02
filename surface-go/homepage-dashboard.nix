{
  config,
  pkgs,
  lib,
  ...
}:

let
  port = 8082;
  portstr = toString port;
in
{
  services.homepage-dashboard = {

    # These options were already present in my configuration.
    enable = true;
    allowedHosts = "localhost:8082,home.bvgcat.de,bvgcat.de";
    openFirewall = true;
    # The following options were what I planned to add.
    # https://gethomepage.dev/latest/configs/settings/
    settings = {
      layout = [
        {
          Glances = {
            header = false;
            style = "row";
            columns = 4;
          };
        }
        {
          Arr = {
            header = true;
            style = "column";
          };
        }
        {
          Downloads = {
            header = true;
            style = "column";
          };
        }
        {
          Media = {
            header = true;
            style = "column";
          };
        }
        {
          Services = {
            header = true;
            style = "column";
          };
        }
      ];
      headerStyle = "clean";
      statusStyle = "dot";
      hideVersion = "true";
    };

    # https://gethomepage.dev/latest/configs/bookmarks/
    bookmarks = [ ];

    # https://gethomepage.dev/latest/configs/services/
    services = [
      {
        "Links" = [
          {
            "animekai.to" = {
              description = "Current best Anime website";
              href = "https://animekai.to/";
            };
          }
        ];
      }
      {
        "Services" = [
          {
            "Nextcloud" = {
              description = "My Nextlcloud instance :)";
              href = "https://cloud.bvgcat.de";
            };
          }
          {
            "Syncthing" = {
              description = "Syncthing Web portal";
              href = "https://sync.bvgcat.de";
            };
          }
        ];
      }
    ];

    # https://gethomepage.dev/latest/configs/service-widgets/
    widgets = [
      {
        openmeteo = {
          label = "Berlin";
          timezone = "Europe/Berlin"; # optional
          units = "metric"; # or imperial
          cache = 5; # Time in minutes to cache API responses, to stay within limits
          #format: # optional, Intl.NumberFormat options
          #  maximumFractionDigits: 1
        };
      }
      {
        resources = {
          cpu = true;
          cputemp = true;
          disk = "/";
          memory = true;
          uptime = true;
          refresh = 1000;
          network = true;
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
          showSearchSuggestions = true;
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

  #systemd = {
  #  services = {
  #    open-homepage = {
  #      description = "Homepage Dashboard";
  #      wantedBy = [ "graphical.target" ];
  #      after = [ "graphical.target" ];

  #      serviceConfig = {
  #        ExecStart = "${pkgs.firefox}/bin/firefox http://localhost:${portstr}";
  #        Restart = "on-failure";
  #        RestartSec = 5;
  #        User = "homeserver";
  #        Environment = [
  #          "MOZ_ENABLE_WAYLAND=1"
  #          "WAYLAND_DISPLAY=wayland-0"
  #          "XDG_RUNTIME_DIR=/run/user/1001" # ← very important
  #        ];
  #      };
  #    };
  #  };
  #};
}
