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
      "192.168.0.110" = [
        "homeserver"
        "home.homeserver"
        "cloud.homeserver"
        "sync.homeserver"
        "lounge.homeserver"
      ];
    };
  };
}