{
  config,
  hostname,
  user,
  ...
}:

let 
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLEKUxvn8ftYTF0opH9Kesf1PAcerJXLsp3feSzxZeC nixos@thinkpad-l14-g2"
  ];
  pwd = "$y$j9T$/zf5NCRBQMN/q3.CqYxE5/$ZOfc4YpigG.RpIihldLKkqH8VCNX4FPrJXxQ2SDvY2D";
in
{
  systemd = {
    services = {
      NetworkManager = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh = {
    enable = true;
    hostKeys = [{ type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }];
  };

  # MMMmmm.2002
  users.users = {
    root = {
      openssh.authorizedKeys.keys = keys;
      hashedPassword = pwd;
    };
    ${user} = {
      isNormalUser = true;
      group = "users";
      hashedPassword = pwd;
      openssh.authorizedKeys.keys = keys;
      extraGroups = [
        "networkmanager"
        "wheel"
        "disk"
      ];
    };
  };
}