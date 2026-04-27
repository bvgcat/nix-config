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

      restic-password.key = "restic-password";
      trans-ext4.key = "trans-ext4";

      home-psk.key = "home-psk";
      ssh_key_homeserver.key = "ssh_key_homeserver";

      homepage-env.key = "homepage-env";
      wg-homeserver.key = "wg-homeserver";
      wg-thinkpad-l14-g2.key = "wg-thinkpad-l14-g2";
      wg-pixel-7.key = "wg-pixel-7";
    };
  };

  # Add 'age' package for CLI usage
  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}
