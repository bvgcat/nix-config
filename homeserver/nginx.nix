{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 8384 ];
  services.syncthing.guiAddress = "http://0.0.0.0:8384";

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    commonHttpConfig = ''
      proxy_headers_hash_max_size 1024;
      proxy_headers_hash_bucket_size 128;
    '';

    virtualHosts = {
      # Root site
      "homeserver" = {
        forceSSL = false;
        enableACME = false;

        locations."/" = {
          proxyPass = "http://localhost:8082";
        };
      };

      # Syncthing
      "sync.homeserver" = {
        forceSSL = false;
        enableACME = false;

        locations."/" = {
          proxyPass = "http://localhost:8384";
        };
      };

      # Deluge
      "deluge.homeserver" = {
        forceSSL = false;
        enableACME = false;

        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.deluge.web.port}";
        };
      };

      # TheLounge
      "lounge.homeserver" = {
        forceSSL = false;
        enableACME = false;

        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.thelounge.port}";
        };
      };

      # Grafana
      "grafana.homeserver" = {
        forceSSL = false;
        enableACME = false;

        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Immich
      "immich.homeserver" = {
        forceSSL = false;
        enableACME = false;

        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;

            proxy_set_header Host              $host;
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            proxy_set_header   Upgrade    $http_upgrade;
            proxy_set_header   Connection "upgrade";
            proxy_redirect     off;

            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
            send_timeout       600s;
          '';
        };
      };

      # Optional: Nextcloud (under /cloud) on root domain
      "cloud.homeserver" = {
        enableACME = true;
        addSSL = true;

        # PHP files
        locations."~ \.php$" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_pass unix:/run/phpfpm/nextcloud.sock;
          '';
        };

        # Disable .htaccess etc.
        locations."~ /\.ht" = {
          return = "404";
        };
      };
    };
  };

  security.acme.acceptTerms = false;
}
