{
  config,
  hostname,
  ...
}:

let
  wlp = "wlp109s0";
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLEKUxvn8ftYTF0opH9Kesf1PAcerJXLsp3feSzxZeC nixos@thinkpad-l14-g2"
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
        shell = "/bin/cryptsetup-askpass";
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
        address = "192.168.178.200";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.178.1";
      interface = wlp;
    };
  };
}