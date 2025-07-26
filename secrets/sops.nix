{
  sops.defaultSopsFile = ./secrets.yaml;
  # YAML is the default
  #sops.defaultSopsFormat = "yaml";
  sops.secrets.secrets = {
    format = "yaml";
    # can be also set per secret
    sopsFile = ./secrets.yaml;
    key = "";
  };
}
