{
  config,
  pkgs,
  lib,
  user,
  ...
}:

{
  # SOPS configuration: point to your age private key file
  sops = {
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    # Define secrets paths that sops-nix should decrypt
    secrets = {
      duckdns.key = "duckdns";

      nc-adminpass.key = "nc-adminpass";
      nc-userpass.key = "nc-userpass";

      ddns-main.key = "ddns-main";
      ddns-cloud.key = "ddns-cloud";
      ddns-home.key = "ddns-home";
      ddns-immich.key = "ddns-immich";
      ddns-sync.key = "ddns-sync";

      restic-password.key = "restic-password";
      trans-ext4.key = "trans-ext4";

      home-psk.key = "home-psk";
      ssh_key_homeserver.key = "ssh_key_homeserver";
    };
  };

  # Add 'age' package for CLI usage
  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}
