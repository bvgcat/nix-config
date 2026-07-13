{ config, user, ... }:

{
  services.syncthing.key = config.sops.secrets.syncthing-key.path;

  sops.secrets = {
    duckdns.key = "duckdns";
    wg-pi3b.key = "wg-pi3b";
    pi3b-rootca-key = {
      key = "pi3b-rootca-key";
      path = "/etc/ssl/local-ca/rootca.key";
    };
    pi3b-ssl-key = {
      key = "pi3b-ssl-key";
      path = "/etc/ssl/local-ca/pi3b.key";
    };
    pi3b-ssl-crt = {
      key = "pi3b-ssl-crt";
      path = "/etc/ssl/local-ca/pi3b.crt";
    };
    syncthing-cert = {
      key = "syncthing-cert-pi3b";
      owner = user;
    };
    syncthing-key = {
      key = "syncthing-key-pi3b";
      owner = user;
    };
    ssh-key-root = {
      key = "ssh-key-pi3b";
      owner = "root";
      mode = "0600";
      path = "/root/.ssh/id_ed25519";
    };
  };
}