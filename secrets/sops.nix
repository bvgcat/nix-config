{ config, pkgs, lib, ... }:

{
  # SOPS configuration: point to your age private key file
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  # Define secrets paths that sops-nix should decrypt
  sops.secrets.duckdns = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
    owner = "godns"; # or the user that runs the godns service
    group = "godns"; # optional, if needed
    mode = "0400";   # optional, default is fine
  };

  sops.secrets.adminpass = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };

  # Add 'age' package for CLI usage
  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}

