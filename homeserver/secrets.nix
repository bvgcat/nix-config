{ config, user, ... }:

{
  services.syncthing.key = config.sops.secrets.syncthing-key.path;

  sops.secrets = {
    syncthing-cert = {
      key = "syncthing-cert-homeserver";
      owner = user;
    };
    syncthing-key = {
      key = "syncthing-key-homeserver";
      owner = user;
    };
    ssh-key-root = {
      key = "ssh-key-homeserver";
      owner = "root";
      mode = "0600";
      path = "/root/.ssh/id_ed25519";
    };

    ssh-key-user = {
      key = "ssh-key-homeserver";
      owner = user;
      group = "users";
      mode = "0600";
      path = "/home/${user}/.ssh/id_ed25519";
    };
  };
}