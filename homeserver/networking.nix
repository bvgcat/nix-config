{
  config,
  hostname,
  ...
}:

let
  wlp = "wlp109s0";
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCOhL7yx0bvprjflceUhcp+Aqv6Wn04VQmIqOpU3+nX nixos@homeserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLEKUxvn8ftYTF0opH9Kesf1PAcerJXLsp3feSzxZeC nixos@thinkpad-l14-g2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEFVUaUD6qmIdaA1j+0sR7nadUqdMD5L8n1MMbdsMyD nixos@surface-go"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjPQFsF4JqDDU50EqLHfh1BUPQW0otVWmAqr7DKN0BX nixos@pi3b"
  ];
in 
{
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeys = keys;
        hostKeys = [ config.sops.secrets.ssh_key_homeserver.path ];
      };
    };
  };

  networking = {
    hostName = hostname;
    networkmanager = {
      wifi.powersave = false;
    };
    usePredictableInterfaceNames = true;

    interfaces.${wlp} = {
      ipv4.addresses = [{
        address = "192.168.0.110";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.0.1";
      interface = wlp;
    };
  };
}