{
  config,
  hostname,
  ...
}:

let
  wlp = "wlp109s0";
in 
{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    hosts = {
      "192.168.178.200" = [  # IP of your NixOS server (adjust as needed)
        "homeserver"
        "immich.homeserver"
        "grafana.homeserver"
        "sync.homeserver"
        "deluge.homeserver"
        "lounge.homeserver"
        "cloud.homeserver"
      ];
    };
  };
}