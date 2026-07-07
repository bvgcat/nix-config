{
  pkgs,
  ...
}:

{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;

    privateKeyFile = "/run/secrets/wg-pi3b";
    peers = [
      {
        publicKey = "3iU/zXCnXO+cri0T+2WJ8pQbj46ETdhO+8wtSFXx7is="; # homeserver
        allowedIPs = [ "10.100.0.2/32" ];
      }
      {
        publicKey = "KCYZ9Sni11MSHEK6ak3fs+Q9vzsiiXI+OEJFOHJdYxM="; # thinkpad-l14-g2
        allowedIPs = [ "10.100.0.3/32" ];
      }
      {
        publicKey = "eWHObqIW8xWo+XMhq6DEEhXSzz74lwbd8kgTFInZzmA="; # pixel-7
        allowedIPs = [ "10.100.0.4/32" ];
      }
      {
        publicKey = "Oe2N+ck/nj1Gjx9ycAHQKts5gWvG93+4zZrHq/WMH14="; # surface-go
        allowedIPs = [ "10.100.0.5/32" ];
      }
    ];
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  networking.nat = {
    enable = true;
    externalInterface = "enu1u1";
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ];
    trustedInterfaces = [ "wg0" ];
    interfaces.wg0.allowedUDPPorts = [ 53 ];
    interfaces.wg0.allowedTCPPorts = [ 53 ];
  };  
}