{ config, user, ... }:

{
  services.syncthing.key = config.sops.secrets.syncthing-key.path;

  sops.secrets = {
    syncthing-key.key = "syncthing-thinkpad";
    ssh-key-root = {
      key = "ssh-key-thinkpad";
      owner = "root";
      mode = "0600";
      path = "/root/.ssh/id_ed25519";
    };

    ssh-key-user = {
      key = "ssh-key-thinkpad";
      owner = user;
      group = "users";
      mode = "0600";
      path = "/home/${user}/.ssh/id_ed25519";
    };
  };
}