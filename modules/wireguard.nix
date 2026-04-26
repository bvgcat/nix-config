{
  config,
  ...
}:
{
 
  networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
      peers = [
        {
          publicKey = "XMhq6DEEhXSzz74lwbd8kgTFInZzmA";
          allowedIPs = [ "0.0.0.0/0" ];
          # Set this to the server IP and port.
          endpoint = "homeserver:51820";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 20;
        }
      ];
    };
  };
}