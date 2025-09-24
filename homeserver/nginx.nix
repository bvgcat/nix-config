{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 8384 ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts."homeserver" = {
      # No SSL or ACME, since you're using internal DNS (e.g., via router)
      forceSSL = false;
      enableACME = false;
      addSSL = false;

      locations = {
        "/" = {
          proxyPass = "http://localhost:8082";
        };

        "/sync/" = {
          proxyPass = "http://localhost:8384";
        };

        "/deluge/" = {
          proxyPass = "http://localhost:${toString config.services.deluge.web.port}";
        };

        "/lounge/" = {
          proxyPass = "http://localhost:${toString config.services.thelounge.port}";
        };

        # Deny .ht* files
        "~ ^/cloud/.*\\.ht" = {
          return = "404";
        };

        # FastCGI for PHP (Nextcloud)
        "~ ^/cloud/.*\\.php$" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_pass unix:/run/phpfpm/nextcloud.sock;
          '';
        };

        # Grafana
        "/grafana/" = {
          proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        # Immich
        "/immich/" = {
          proxyPass = "http://[::1]:${toString config.services.immich.port}";
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
    };
  };

  # No ACME because you're using an internal domain
  security.acme.acceptTerms = false;
}
