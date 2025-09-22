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
    wireless = {
      enable = true;
      # this makes wpa_supplicant read /run/secrets/wifi at runtime
      #secretsFile = config.sops.secrets.home-psk.path;
      #networks = {
      #  "Apartment 727-30-11-41" = {
      #    pskRaw = "ext:home-psk";    # use the name inside your secrets file
      #  };
      #};    
    };
  };
}