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
  };
}