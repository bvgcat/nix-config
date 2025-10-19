{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 2283 8082 8112 8384 9000 ];
  services.syncthing.guiAddress = "http://0.0.0.0:8384";

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    commonHttpConfig = ''
      proxy_headers_hash_max_size 1024;
      proxy_headers_hash_bucket_size 128;
    '';

    virtualHosts."homeserver" = {
      forceSSL = false;
      enableACME = false;

      locations = {
        "/" = {
          proxyPass = "http://[::1]:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };

        "/home" = {
          proxyPass = "http://127.0.0.1:8082";
        };

        "/sync/" = {
          proxyPass = "http://127.0.0.1:8384";
        };

        "/deluge/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.deluge.web.port}";
        };

        "/lounge/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.thelounge.port}";
        };

        "/grafana/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        "/nextcloud/" = {
          priority = 9999;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto http;
            proxy_pass http://127.0.0.1:8080/; # tailing / is important!
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_redirect off;
          '';
        };

        "^~ /.well-known" = {
          priority = 9000;
          extraConfig = ''
            absolute_redirect off;
            location ~ ^/\\.well-known/(?:carddav|caldav)$ {
              return 301 /nextcloud/remote.php/dav;
            }
            location ~ ^/\\.well-known/host-meta(?:\\.json)?$ {
              return 301 /nextcloud/public.php?service=host-meta-json;
            }
            location ~ ^/\\.well-known/(?!acme-challenge|pki-validation) {
              return 301 /nextcloud/index.php$request_uri;
            }
            try_files $uri $uri/ =404;
          '';
        };
      };
    };
  };
}

