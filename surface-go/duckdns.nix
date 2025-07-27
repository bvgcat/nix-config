{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.duckdns = {
    enable = true;
    tokenFile = config.sops.secrets.duckdns.path;
    domains = [ "hs-bvgcat" ];
  };
}