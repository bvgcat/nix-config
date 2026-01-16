{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 2283 8082 8384 9000 ];
  services.syncthing.guiAddress = "http://0.0.0.0:8384";

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    commonHttpConfig = ''
      proxy_headers_hash_max_size 1024;
      proxy_headers_hash_bucket_size 128;
    '';

    virtualHosts = {
      "homeserver" = {
        locations."/" = {
          proxyPass = "http://[::1]:2283";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
          '';
        };
      };
      "home.homeserver" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8082";
          recommendedProxySettings = true;
        };
      };
      "sync.homeserver" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
        };
      };
      "lounge.homeserver" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
        };
      };
    };
  };
}

