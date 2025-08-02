{
  config,
  pkgs,
  lib,
  ...
}:

{
  # SOPS configuration: point to your age private key file
  sops = {
    age.keyFile = "/root/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    # Define secrets paths that sops-nix should decrypt
    secrets = {
      duckdns.key = "duckdns";
      adminpasss.key = "adminpass";
      ddns-cloud.key = "ddns-cloud";
      ddns-home.key = "ddns-home";
      ddns-sync.key = "ddns-sync";
    };
  };

  # Add 'age' package for CLI usage
  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}
