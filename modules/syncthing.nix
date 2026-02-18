{
  config,
  pkgs,
  lib,
  user,
  ...
}:

let 
  port = 8384;
in
{
  environment.systemPackages = with pkgs; [
    syncthing
  ];
  services.syncthing = {
    enable = true;
    user = user;
    configDir = "/home/${user}/.config/syncthing";
    databaseDir = "/home/${user}/";
    overrideDevices = true;

    settings = {
      options.urAccepted = -1;
      gui.user = "admin";
      gui.password = "$2a$10$HaLAXjOdbqddkhWyuJ5cPOooMH/XxlqNSlqxhaLqng2XZLHbfsilG";
      gui.theme = "black";
      devices = {
        "homeserver" = {
          id = "YHM74UR-MW3ZMBC-KFDSUFG-CSWEWEI-GNJH3UC-5Q7FCII-Y34KIWJ-PO7EPQG";
          autoAcceptFolders = true;
        };
        "nixos@thinkpad-l14-g2" = {
          id = "6LYC6WJ-LUAIHJT-JMFJST6-XTWAZ6R-LUD5RF2-5KKGDKK-VE2CMQ7-BTKD7Q6";
          autoAcceptFolders = true;
        };
        "nixos@surface-go" = {
          id = "D6OI2T3-2EVREJA-ZHNHZ5B-63IRD3P-HH3XAHX-YUZY7P6-2OWPEYD-BGLKNQM";
          autoAcceptFolders = true;
        };
        "Pixel 7" = {
          id = "EPITZLR-6Y2XEK4-G5QRYT2-4DNBP3D-FHIH4D2-MLC7DXY-U2ZOQMH-UMHUYQ3";
          introducer = true;
          autoAcceptFolders = true;
        };
        "pi3b" = {
          id = "3WU2KZJ-FZHIYKV-IYPPGST-WA77JLU-FQ2L5YW-7HQYOLA-LXMVEL7-VIXZMAD";
          autoAcceptFolders = true;
        };
      };
    };
    openDefaultPorts = true;
  };
}
