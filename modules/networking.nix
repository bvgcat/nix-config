{
  config,
  hostname,
  ...
}:

let
  wlp = "wlp109s0";
in 
{
  networking.firewall.allowedTCPPorts = [ 24800 ];
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    hosts = {
      "192.168.0.110" = [
        "homeserver"
        "home.homeserver"
        "cloud.homeserver"
        "sync.homeserver"
        "lounge.homeserver"
      ];
    };
  };
  
  security.pki.certificates = [''
    -----BEGIN CERTIFICATE-----
    MIIFYTCCA0mgAwIBAgIUTFTiG8w1poE9iHeMtuxUBlnoR+cwDQYJKoZIhvcNAQEL
    BQAwQDELMAkGA1UEBhMCREUxEzARBgNVBAoMCkhvbWVzZXJ2ZXIxHDAaBgNVBAMM
    E0hvbWVzZXJ2ZXIgTG9jYWwgQ0EwHhcNMjYwMTI0MDA0MTE3WhcNMzYwMTIyMDA0
    MTE3WjBAMQswCQYDVQQGEwJERTETMBEGA1UECgwKSG9tZXNlcnZlcjEcMBoGA1UE
    AwwTSG9tZXNlcnZlciBMb2NhbCBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCC
    AgoCggIBANxT9okomxAlDaeFzadKFaaYCYWHT/27boztF0oXwslPFh8MP9HvxIm6
    MTeupNZ28OqLXvYUAJgO9TyBiPLp8jXVxtu3CdbfCNBj83JKM77T3556SOozhYPd
    j3c87yaPgcnbkBnxZ/MfiaEdS9Ew7eKqMqp8SksCXEYoWdW2F+eW/i1NSN4e5A9/
    d+bqho1Q2pVYSN52Ouo8ObIBS8MVNp5AcTzUffsHrIE+aj9NLi8lNjBRtdEDbC83
    r+5v+A7dJmJ47MW1bOBlHiXNj3ZgtQYWLy1qun65tUCNkbtbWNwjynwKw5LQM7AH
    FX2K/4TZ8Y/RLdofcD8tnCLk7EZqhjbc7H5L7zqrkFaHcEOYcEBYpED75HA4/4YO
    0K1ASMr/8f8RVHs+u4bBFL0pi7DY9H0QY0vl7OBodDfKiJVJq8i8M7CyLD7HBm+T
    MeO1MIO4yHgf3J1G5Nc9yEjw/N9Ngo/YMIWyAdmoUC5GQI5fWDqxNszabYE/gxnJ
    oWP9EP7Mf2PQWc4BRwPV4xirHZ/XbFM+jHyrgSC2te8uoScSBZRdpBvo75zonrXm
    pQoxE2AvyqJP6kLC4w8XVocZ2Uw4n+OEJwxQydPVf6EQa1qk13DaYHakBfGITvQK
    9UbR9P16zLS+pSg477Lgzd7z5ZCr55gIPqNSU563DhN5S8dkf1PXAgMBAAGjUzBR
    MB0GA1UdDgQWBBSZ6HXOB+DqZmJhcgp3eyrNSnWECTAfBgNVHSMEGDAWgBSZ6HXO
    B+DqZmJhcgp3eyrNSnWECTAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUA
    A4ICAQBSZaL+MUlMxSiqet1ukRFFI+zSesqQMb18zzqS6DTUr5cj0PaCIR2cn4JY
    u3V/wKIAzQX5CghVvP7M+alicOF7WBlD42Kyw3fnt5CnKOgeq1JEChYzYGV7QWGv
    hemfhXL3Nx+0xDqU/LTU1SzS2hfVdKj3AXJVc+PjUZsHWBzj7dbud1L8kf+ncrL4
    3cFLLkTm0UW2zooIWfKZUjOmtsSvCUmg1xJpRkEjngKY2tLwhHP0owa7501o4xje
    pWgEzoa2Gu3/pap+ToerjgpnBcvShPJT8tc38mCb4vK2jEp5SP16wwmhPC2O7GEc
    +E/e1AtIhCNaowLtuL8IIYnoxLWc+Z8wJ/YZfdUjtq+3O7+y35SYMxT8GEDhL1tp
    Jy7ATtrlIU0o7rJlFN1bu6Ng19FCsabEffJgQKUctkdBUMsZVUWJo5lzNM+v5Tpa
    qo7jjDf39Z0uKJKUFvcfa7DypFkmEwAqV1hWF8mQvpAOInyuqhaaMpI+57mOHotb
    SN0kCbFMaHoH63XdbmMrq9j+gesJL7HfFWvsgRkfJe6pSSZ7LTciSg2inPLt/dz0
    s5Z4o+QsHJTLqHwGNtcQO54LpBS7lfgkbNNOdeVrsIb3k43OOBqhIv24mCJJ5hNx
    aNC+kzDpEXT41IGusCr8z0NmcMWZBSfNpwsfQ/Dj2MNM/PIWVg==
    -----END CERTIFICATE-----
  ''];
}