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

      nc-adminpass.key = "nc-adminpass";
      nc-userpass.key = "nc-userpass";

      ddns-main.key = "ddns-main";
      ddns-cloud.key = "ddns-cloud";
      ddns-home.key = "ddns-home";
      ddns-immich.key = "ddns-immich";
      ddns-sync.key = "ddns-sync";

      home-ssid = { };
      home-psk = { };
    };
  };

  # Add 'age' package for CLI usage
  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}
