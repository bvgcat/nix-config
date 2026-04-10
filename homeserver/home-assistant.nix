{
  config,
  pkgs,
  lib,
  hostname,
  user,
  ...
}:

{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];
    config = {
      http = {
        server_host = "::1";
        trusted_proxies = [ "::1" "127.0.0.1" ];
        use_x_forwarded_for = true;
      };
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };
}