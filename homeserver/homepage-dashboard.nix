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
    environmentFiles = [ config.sops.secrets.homepage-env.path ];
    # https://gethomepage.dev/latest/configs/settings/
    settings = {
      layout = [
        {
          Glances = {
            header = false;
            style = "row";
            columns = 2;
          };
        }
        {
          Calendars = {
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
      fullWidth = true;
      hideVersion = true;
    };

    # https://gethomepage.dev/latest/configs/bookmarks/
    bookmarks = [ ];

    # https://gethomepage.dev/latest/configs/services/
    services = [
      {
      "Calendars" = [          {
          "Agenda" = {
              widget = {
                type = "calendar";
                view = "agenda";
                previousDays = 2;
                showTime = true;
                integrations = [
                  {
                    type = "ical";
                    url = "https://isis.tu-berlin.de/calendar/export_execute.php?userid=101064&authtoken=c88afeb0577b890665c1c1d16c32013f188e672f&preset_what=all&preset_time=custom";
                    name = "ISIS";
                    color = "red";
                  }
                ];
              };
            };
          }
          {
          "Calender" = {
              widget = {
                type = "calendar";
                firstDayInWeek = "monday";
                view = "monthly";
                integrations = [
                  {
                    type = "ical";
                    url = "https://isis.tu-berlin.de/calendar/export_execute.php?userid=101064&authtoken=c88afeb0577b890665c1c1d16c32013f188e672f&preset_what=all&preset_time=custom";
                    name = "ISIS";
                    color = "red";
                  }
                ];
              };
            };
          }
        ];
      }
      {
        "Services" = [
          {
            "Immich" = {
              icon = "immich.svg";
              description = "Self-hosted photo and video management solution";
              href = "https://immich.homeserver";
              ping = "https://immich.homeserver";
              widget = {
                type = "immich";
                url = "https://immich.homeserver";
                key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
                version = 2;
              };
            };
          }
          {
            "Nextcloud" = {
              icon = "nextcloud.svg";
              description = "My Nextlcloud instance :)";
              href = "https://cloud.homeserver";
              ping = "https://cloud.homeserver";              
              widget = {
                type = "nextcloud";
                url = "https://cloud.homeserver";
                username = "{{HOMEPAGE_VAR_NEXTCLOUD_USERNAME}}";
                password = "{{HOMEPAGE_VAR_NEXTCLOUD_PASSWORD}}";
              };
            };
          }
          {
            "Pi-hole" = {
              icon = "pi-hole.svg";
              description = "Pi-hole dashboard";
              href = "https://pi-hole.pi3b";
              ping = "https://pi-hole.pi3b";              
              widget = {
                type = "pihole";
                url = "https://pi-hole.pi3b";
                version = 6;
              };
            };
          }
          {
            "Minecraft" = {
              icon = "minecraft.svg";
              description = "Main Minecraft Server";
              widget = {
                type = "minecraft";
                url = "udp://localhost:25565";
              };
            };
          }
          {
            "Syncthing" = {
              icon = "syncthing.svg";
              description = "Syncthing Web portal";
              href = "https://sync.homeserver";
              ping = "https://sync.homeserver";
            };
          }
          {
            "The Lounge" = {
              icon = "thelounge.svg";
              description = "The Lounge web IRC client";
              href = "https://lounge.homeserver";
              ping = "https://lounge.homeserver";
            };
          }
          {
            "Home Assistant" = {
              icon = "home-assistant.svg";
              description = "Home automation dashboard";
              href = "https://assistant.homeserver";
              ping = "https://assistant.homeserver";
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
