{ config, user, ... }:

{
  services.syncthing.key = config.sops.secrets.syncthing-key.path;

  sops.secrets = {
    duckdns.key = "duckdns";
    syncthing-cert = {
      key = "syncthing-cert-pi3b";
      owner = user;
      path = "/home/${user}/.config/syncthing/cert.pem";
    };
    syncthing-key = {
      key = "syncthing-key-pi3b";
      owner = user;
      path = "/home/${user}/.config/syncthing/key.pem";
    };
    ssh-key-root = {
      key = "ssh-key-pi3b";
      owner = "root";
      mode = "0600";
      path = "/root/.ssh/id_ed25519";
    };
  };
}