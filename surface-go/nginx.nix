{
  self,
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    firewall.allowedTCPPorts = [
      80
      443
      8082
      8384
    ];
    tempAddresses = "disabled";
  };
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "cloud.bvgcat.de" = {
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

      "bvgcat.de" = {
        enableACME = true;
        addSSL = true;
        serverAliases = [ "home.bvgcat.de" ];
        locations."/".proxyPass = "http://localhost:8082";
      };

      "sync.bvgcat.de" = {
        enableACME = true;
        addSSL = true;
        locations."/".proxyPass = "https://localhost:8384";
      };

      "immich.bvgcat.de" = {
        enableACME = true;
        addSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            # allow large file uploads
            client_max_body_size 50000M;

            # Set headers
            proxy_set_header Host              $host;
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # enable websockets: http://nginx.org/en/docs/http/websocket.html
            proxy_set_header   Upgrade    $http_upgrade;
            proxy_set_header   Connection "upgrade";
            proxy_redirect     off;

            # set timeout
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
            send_timeout       600s;
          '';
        };
      };
    };
  };

  systemd = {
    services.update-ddns = {
      description = "DynamicDNS Update";
      path = with pkgs; [
        curl
        iproute2
        gawk
      ];
      script = ''
        IP6=$(ip -6 addr show dev wlp1s0 scope global | grep inet6 | awk '{print $2}' | cut -d/ -f1 | head -n1)
        PASSWORD=$(cat ${config.sops.secrets.ddns-main.path})
        curl -s "https://dynamicdns.key-systems.net/update.php?hostname=bvgcat.de&password=$PASSWORD&ip=$IP6"
        PASSWORD=$(cat ${config.sops.secrets.ddns-cloud.path})
        curl -s "https://dynamicdns.key-systems.net/update.php?hostname=cloud.bvgcat.de&password=$PASSWORD&ip=$IP6"
        PASSWORD=$(cat ${config.sops.secrets.ddns-sync.path})
        curl -s "https://dynamicdns.key-systems.net/update.php?hostname=sync.bvgcat.de&password=$PASSWORD&ip=$IP6"
        PASSWORD=$(cat ${config.sops.secrets.ddns-home.path}) 
        curl -s "https://dynamicdns.key-systems.net/update.php?hostname=home.bvgcat.de&password=$PASSWORD&ip=$IP6"        
        PASSWORD=$(cat ${config.sops.secrets.ddns-immich.path}) 
        curl -s "https://dynamicdns.key-systems.net/update.php?hostname=immich.bvgcat.de&password=$PASSWORD&ip=$IP6"   
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
    timers.update-ddns = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "60min";
        Unit = "update-ddns.service";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "hamzatamim.ht@gmail.com";
  };

  environment.systemPackages = with pkgs; [
    curl
    iproute2
    gawk
  ];
}

# PASSWORD=$(cat ${config.sops.secrets.ddns-sync.path})
# curl -6 -s "https://dynamicdns.key-systems.net/update.php?hostname=sync.bvgcat.de&password=$PASSWORD&ip=auto"
# PASSWORD=$(cat ${config.sops.secrets.ddns-home.path})
# curl -6 -s "https://dynamicdns.key-systems.net/update.php?hostname=home.bvgcat.de&password=$PASSWORD&ip=auto"
