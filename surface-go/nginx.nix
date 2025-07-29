{
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "cloud.bvgcat.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "https://unix:/run/nextcloud/nextcloud.sock";
      };

      "sync.bvgcat.de" = {
        enableACME = true;
        addSSL = true;
        locations."/".proxyPass = "https://unix:/run/syncthing/syncthing.sock";
      };

      "home.bvgcat.de" = {
        enableACME = true;
        addSSL = true;
        locations."/".proxyPass = "http://localhost:8082";
      };

      # Example for another subdomain
      # "onlyoffice.example.com" = {
      #   enableACME = true;
      #   forceSSL = true;
      #   addSSL = true;
      # };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "hamzatamim.ht@gmail.com";
  };
}