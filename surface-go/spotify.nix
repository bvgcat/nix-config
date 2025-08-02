{
  pkgs,
  ...
}:

{
  systemd = {
    services = {
      open-spotify = {
        description = "Start Spotify after boot";
        wantedBy = [ "graphical.target" ];
        after = [ "graphical.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.spotify}/bin/spotify";
          User = "homeserver";
          RestartSec = 60;
        };
      };
    };
  };
}