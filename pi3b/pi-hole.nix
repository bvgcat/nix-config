{ pkgs, ... }:
{
  services.pihole-ftl.package = pkgs.pihole-ftl.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      pkgs.lld
      pkgs.autoPatchelfHook
    ];
    NIX_CFLAGS_LINK = (old.NIX_CFLAGS_LINK or "")
      + " -fuse-ld=lld -Wl,--fix-cortex-a53-843419";
  });

  services.pihole-ftl = {
    enable = true;
    openFirewallWebserver = true;
    openFirewallDNS = true;
    openFirewallDHCP = true;

    settings = {
      dns = {
        upstreams = [ "1.1.1.1" "9.9.9.9" ];
        hosts = [
          "192.168.0.100 pi.hole"
          "192.168.0.100 pi.hole.pi"
          "10.100.0.1 pi.hole"
          "10.100.0.1 pi.hole.pi"
          "10.100.0.1 pi3b"

          "10.100.0.2 homeserver"
          "10.100.0.2 immich.homeserver"
          "10.100.0.2 home.homeserver"
          "10.100.0.2 cloud.homeserver"
          "10.100.0.2 sync.homeserver"
          "10.100.0.2 assistant.homeserver"
          "10.100.0.2 lounge.homeserver"

          "10.100.0.3 thinkpad-l14-g2"
          "10.100.0.4 pixel-7"
          "10.100.0.5 surface-go"
        ];
        listenInterface = "all";
      };
    };

    lists = [
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
        type = "block";
        enabled = true;
        description = "hagezi blocklist";
      }
    ];
  };

  services.pihole-web = {
    enable = true;
    ports = [ "443s" ];
  };
}