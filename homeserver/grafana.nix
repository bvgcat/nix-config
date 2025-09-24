{
  config,
  user,
  hostname,
  ...
}:

{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        # Listening Address
        http_addr = "localhost";
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        domain = "homeserver";
        root_url = "https:homeserver/grafana/"; # Not needed if it is `https://your.domain/`
        serve_from_sub_path = true;
      };
    };
  };
}