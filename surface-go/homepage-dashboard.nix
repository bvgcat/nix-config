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
              href = "https://animekai.to/";
            };
          }
          {
            "FRITZ!Box 4050" = {
              description = "Current best Anime website";
              href = "https://192.168.178.1/";
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
              href = "https://immich.bvgcat.de";
            };
          }
          {
            "Nextcloud" = {
              icon = "nextcloud.svg";
              description = "My Nextlcloud instance :)";
              href = "https://cloud.bvgcat.de";
            };
          }
          {
            "Syncthing" = {
              icon = "syncthing.svg";
              description = "Syncthing Web portal";
              href = "https://sync.bvgcat.de";
            };
          }
          {
            "Deluge" = {
              icon = "deluge.svg";
              description = "Torrent servive";
              href = "https://deluge.bvgcat.de";
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
}
