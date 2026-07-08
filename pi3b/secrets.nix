{ config, user, ... }:

{
  services.syncthing.key = config.sops.secrets.syncthing-key.path;

  sops.secrets = {
    duckdns.key = "duckdns";
    syncthing-key.key = "syncthing-pi3b";
    ssh-key-root = {
      key = "ssh-key-pi3b";
      owner = "root";
      mode = "0600";
      path = "/root/.ssh/id_ed25519";
    };
  };
}