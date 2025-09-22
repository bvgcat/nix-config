{
  config,
  hostname,
  ...
}:

let
  wlp = "wlp109s0";
in 
{
  boot.initrd = {
    kernelParams = [ "ip=dhcp" ];
    availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLEKUxvn8ftYTF0opH9Kesf1PAcerJXLsp3feSzxZeC nixos@thinkpad-l14-g2"
        ];
        hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" ];
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