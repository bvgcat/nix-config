{
  config,
  hostname,
  ...
}:

let
  wlp = "wlp1s0";
  eth = "eth1s0";
in 
{
  boot.initrd.network.ssh = {
    enable = true;
    port = 22;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
    ];
    # let nixos handle host key generation
    hostKeys = [];
    #shell = "/bin/cryptsetup-askpass";
  };


  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };

  #services.miniupnpd = {
  #  enable = true;
  #  upnp = true;
  #};

  networking = {
    hostName = hostname;

    networkmanager = {
      wifi.powersave = false;
    };
    usePredictableInterfaceNames = true;

    wireless.networks = {
      "${config.sops.secrets.home-ssid.value}" = {
        psk = config.sops.secrets.home-pwd.value;
      };
    };                                

    tempAddresses = "disabled";
    interfaces.${wlp} = {
      ipv6.addresses = [{
        address = "2001:1438:4018:4fa0:5984:bf97:3616:bec2";
        prefixLength = 64;
      }];
      ipv4.addresses = [{
        address = "192.168.178.200";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.178.1";
      interface = wlp;
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = wlp;
    };
  };
}