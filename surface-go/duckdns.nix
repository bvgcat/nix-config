{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.duckdns = {
    enable = true;
    tokenFile = "/run/secrets/duckdns";
    domains = [ "hs-bvgcat" ];
  };
}
