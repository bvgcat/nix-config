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

  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeys =  [
          # change this to your ssh key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
        ];
        hostKeys = [ "/etc/ssh/ssh_host_rsa_key" ];
      };
    };
  };


  networking = {
    hostName = hostname;
    wireless = {
      networks.${config.sops.secrets.home-ssid}.psk = config.sops.secrets.home-pwd.value;
    };                                              

    tempAddresses = "disabled";
    interfaces.wlp = {
      ipv6.addresses = [{
        address = "2001:1438:4018:4fa0:c28e:5d42:af6e:40aa";
        prefixLength = 64;
      }];
      ipv4.addresses = [{
        address = "192.168.178.200";
        prefixLength = 24;
      }];
    };
    #defaultGateway = {
    #  address = "192.168.178.0";
    #  interface = wlp;
    #};
    #defaultGateway6 = {
    #  address = "fe80::1";
    #  interface = wlp;
    #};
  };
}