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
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "*";
    openFirewall = true;
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
      hideVersion = true;
    };

    # https://gethomepage.dev/latest/configs/bookmarks/
    bookmarks = [ ];

    # https://gethomepage.dev/latest/configs/services/
    services = [
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
          {
            "Home Assistant" = {
              icon = "home-assistant.svg";
              description = "Home automation dashboard";
              href = "https://assistant.homeserver";
            };
          }
        ];
      }
    ];

    # https://gethomepage.dev/latest/configs/service-widgets/
    widgets = [
      {
        datetime = {
          locale = "de";
          format = {
            dateStyle = "short";
            timeStyle = "short";
          };
        };
      }
      {
        openmeteo = {
          label = "Berlin";
          latitude = 52.5200;
          longitude = 13.4050;
          timezone = "Europe/Berlin";
          units = "metric";
          cache = 10;
        };
      }
      {
        resources = {
          cpu = true;
          cputemp = true;
          disk = "/";
          memory = true;
          uptime = true;
          refresh = 500;
          network = true;
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
}
