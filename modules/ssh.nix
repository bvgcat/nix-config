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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEFVUaUD6qmIdaA1j+0sR7nadUqdMD5L8n1MMbdsMyD m@surface-go"
  ];
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

  users.users = {
    root.openssh.authorizedKeys.keys = keys;
    ${user}.openssh.authorizedKeys.keys = keys;
  };
}