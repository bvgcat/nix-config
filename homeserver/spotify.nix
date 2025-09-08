{
  pkgs,
  ...
}:

let
  mdns = 5353;
  tcp = 8050;
in
{
  networking.firewall.allowedUDPPorts = [ mdns ];
  networking.firewall.allowedTCPPorts = [ tcp ];

  environment.systemPackages = with pkgs; [ 
    spotify 
    spotifyd
    tidal-hifi
  ];

  services.spotifyd = {
    enable = true;
    settings.global = {
      device_name = "homeserver";
      device_type = "speaker";
      disable_discovery = false;
      zeroconf_port = tcp;
      bitrate = 320;
      initial_volume = 50;
      volume_normalisation = true;
      autoplay = false;
    };
  };
}
