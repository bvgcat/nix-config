{
  services.pihole-ftl = {
  enable = true;
  openFirewallWebserver = true;
  openFirewallDNS = true;
  openFirewallDHCP = true;

  settings = {
    # See <https://docs.pi-hole.net/ftldns/configfile/>
    # External DNS Servers quad9 and cloudflare
    dns.upstreams = [ "9.9.9.9" "1.1.1.1" ];
    # Optionally resolve local hosts (domain is optional)
    dns.hosts = [ "192.168.1.188 hostname.domain" ];
    dns.listenInterface = "all";
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