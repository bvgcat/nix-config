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
    age.keyFile = "/var/lib/sops/key.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    # Define secrets paths that sops-nix should decrypt
    secrets = {
      nc-adminpass.key = "nc-adminpass";
      nc-userpass.key = "nc-userpass";

      restic-password.key = "restic-password";

      homepage-env.key = "homepage-env";
      wg-pi3b.key = "wg-pi3b";
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
