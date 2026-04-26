{
  pkgs,
  ...
}:

{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;

    privateKeyFile = "/etc/wireguard/server.key";
    peers = [
      {
        publicKey = "KCYZ9Sni11MSHEK6ak3fs+Q9vzsiiXI+OEJFOHJdYxM="; # thinkpad-l14-g2
        allowedIPs = [ "10.100.0.2/32" ];
      }
      {
        publicKey = "eWHObqIW8xWo+XMhq6DEEhXSzz74lwbd8kgTFInZzmA="; # pixel-7
        allowedIPs = [ "10.100.0.3/32" ];
      }
    ];

    # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
      ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
    '';

    # Undo the above
    preShutdown = ''
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
      ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
    '';
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  networking.nat = {
    enable = true;
    externalInterface = "wlp109s0";
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ];
    trustedInterfaces = [ "wg0" ];
    interfaces.wg0.allowedUDPPorts = [ 53 ];
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true;

    settings = {
      domain-needed = true;
      bogus-priv = true;

      "listen-address" = [
        "127.0.0.1"
        "10.100.0.1"
      ];

      local = "/homeserver/";
      address = [
        "/immich.homeserver/192.168.0.110"
        "/home.homeserver/192.168.0.110"
        "/cloud.homeserver/192.168.0.110"
        "/sync.homeserver/192.168.0.110"
        "/assistant.homeserver/192.168.0.110"
        "/lounge.homeserver/192.168.0.110"
      ];
    };
  };
  
}