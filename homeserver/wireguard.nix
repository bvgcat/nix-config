{
  ...
}:

{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;

    privateKeyFile = "/etc/wireguard/server.key";
    peers = [
      {
        publicKey = "eWHObqIW8xWo+XMhq6DEEhXSzz74lwbd8kgTFInZzmA=";
        allowedIPs = [ "10.100.0.2/32" ];
      }
    ];
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
      address = "/homeserver/10.100.0.1";
    };
  };
}