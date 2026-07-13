{
  config,
  pkgs,
  lib,
  user,
  ...
}:

{
  # Add 'age' package for CLI usage
  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  sops = {
    age.keyFile = "/var/lib/sops/key.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
