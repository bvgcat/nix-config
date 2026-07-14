{
  hostname,
  ...
}:

{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  networking = {
    hostName = hostname;
    firewall= {
      allowedUDPPorts = [ 51820 ];  # wireguard
      allowedTCPPorts = [ 24800 ];
    };
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
  
  security.pki.certificateFiles = [
    ../certs/rootca.crt
  ];
}