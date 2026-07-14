{ config, user, ... }:

{
  services.syncthing.key = config.sops.secrets.syncthing-key.path;

  sops.secrets = {
    nc-adminpass.key = "nc-adminpass";
    nc-userpass.key = "nc-userpass";
    restic-password.key = "restic-password";
    homepage-env.key = "homepage-env";
    homeserver-rootca-key = {
      key = "homeserver-rootca-key";
      path = "/etc/ssl/local-ca/rootca.key";
    };
    homeserver-ssl-key = {
      key = "homeserver-ssl-key";
      path = "/etc/ssl/local-ca/homeserver.key";
      owner = "nginx";
      group = "nginx";
      mode = "0400";
    };
    homeserver-ssl-crt = {
      key = "homeserver-ssl-crt";
      path = "/etc/ssl/local-ca/homeserver.crt";
      owner = "nginx";
      group = "nginx";
      mode = "0444";
    };
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