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
      allowedTCPPorts = [ 24800 ];  # input-leap
    };
    networkmanager.enable = true;
  };
  
  security.pki.certificateFiles = [
    ../certs/rootca.crt
  ];
}