{
  config,
  pkgs,
  lib,
  ...
}:

{

  services.homepage-dashboard = {
    enable = true;
    listenPort = "8080";
    allowedHosts = "";
    openFirewall = false;
    bookmarks = [ ];
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ];
    settings = { }; # see https://gethomepage.dev/configs/settings/
    services = [ ]; # see https://gethomepage.dev/configs/services/

  };
}
