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
        http_addr = "127.0.0.1";
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        domain = "grafana.homeserver";
      };
    };
  };
}