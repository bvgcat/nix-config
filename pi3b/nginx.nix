{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [ 
    80
    443 
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "pi-hole.pi3b" = {
        addSSL = true;
        kTLS = false;
        sslCertificate = "/etc/ssl/local-ca/pi3b.crt";
        sslCertificateKey = "/etc/ssl/local-ca/pi3b.key";
        locations."/" = {
          proxyPass = "https://127.0.0.1:3424";
          recommendedProxySettings = true;
        };
      };
    };
  };
}

