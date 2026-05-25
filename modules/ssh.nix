{
  config,
  hostname,
  user,
  ...
}:

let 
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCOhL7yx0bvprjflceUhcp+Aqv6Wn04VQmIqOpU3+nX root@homeserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLEKUxvn8ftYTF0opH9Kesf1PAcerJXLsp3feSzxZeC nixos@thinkpad-l14-g2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEFVUaUD6qmIdaA1j+0sR7nadUqdMD5L8n1MMbdsMyD nixos@surface-go"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjPQFsF4JqDDU50EqLHfh1BUPQW0otVWmAqr7DKN0BX nixos@pi3b"
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