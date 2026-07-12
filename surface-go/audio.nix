{
  pkgs,
  ...
}:

let
  mdns = 5353;
  tcp = 8050;
in
{
  networking.firewall.allowedUDPPorts = [ mdns 8888 ];
  networking.firewall.allowedTCPPorts = [ tcp 8888 ];

  environment.systemPackages = with pkgs; [  
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
    spotifyd
    tidal-hifi
  ];

  services.spotifyd = {
    enable = true;
    settings.global = {
      device_name = "surface-go";
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
