{
  config,
  pkgs,
  lib,
  ...
}:

let
  port = 8082;
in
{
  networking.firewall.allowedTCPPorts = [ port ];
  services.homepage-dashboard = {

    # These options were already present in my configuration.
    enable = true;
    allowedHosts = "localhost:${toString port},home.homeserver,homeserver/home,homeserver:8082";
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
        "Other" = [
          {
            "animekai.to" = {
              description = "Current best Anime website";
              href = "http://animekai.to/";
            };
          }
          {
            "FRITZ!Box 4050" = {
              description = "Current best Anime website";
              href = "http://192.168.0.1/";
            };
          }
        ];

      }
      {
        "Server" = [
          {
            "Immich" = {
              icon = "immich.svg";
              description = "Self-hosted photo and video management solution";
              href = "https://homeserver";
            };
          }
          {
            "Nextcloud" = {
              icon = "nextcloud.svg";
              description = "My Nextlcloud instance :)";
              href = "https://cloud.homeserver";
            };
          }
          {
            "Syncthing" = {
              icon = "syncthing.svg";
              description = "Syncthing Web portal";
              href = "https://sync.homeserver";
            };
          }
          {
            "The Lounge" = {
              icon = "thelounge.svg";
              description = "The Lounge web IRC client";
              href = "https://lounge.homeserver";
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
          latitude = 52.5200;
          longitude = 13.4050;
          timezone = "Europe/Berlin"; # optional
          units = "metric"; # or imperial
          cache = 10; # Time in minutes to cache API responses, to stay within limits
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
        immich = {
          url = "http://localhost:${config.services.immich.port}";
          key = "IKWwGv8Mw10LYR2e7f3bEAofDvE0KKKwSmYWbMLI8";
          version = 2;
        };
      }
      {
        speedtest = {
          url = http://speedtest.host.or.ip;
          version = 2;
          bitratePrecision = 2;
        }
      }
      {
        calender = {
          firstDayInWeek = "sunday";
          view = "monthly";
          maxEvents = 10;
          showTime = true;
        }
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
}
