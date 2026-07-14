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
          "192.168.0.100 pi3b"
          "192.168.0.100 pi-hole.pi3b"

          "192.168.0.112 homeserver"
          "192.168.0.112 immich.homeserver"
          "192.168.0.112 home.homeserver"
          "192.168.0.112 cloud.homeserver"
          "192.168.0.112 sync.homeserver"
          "192.168.0.112 assistant.homeserver"
          "192.168.0.112 lounge.homeserver"

          "192.168.0.113 thinkpad-l14-g2"
          "192.168.0.114 pixel-7"
          "192.168.0.115 surface-go"
        ];
        listenInterface = "all";
      };
      webserver.tls.cert = "/var/lib/pihole/tls.pem";
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