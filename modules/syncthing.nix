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
        "XQ-DC54" = {
          id = "C6BH2I7-UX4FGTM-7RFN4ZN-QQXOTU2-BFZOL7C-PS2I43T-QB5HBWG-R3OB3A5";
          autoAcceptFolders = true;
        };
        "nixos@latitude-5290" = {
          id = "NG5MYM5-FAWXKH4-7CUGTQM-LAUFPXE-NRPTDG5-TLKNHLC-47BOMEY-W7TE4AM";
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
        "pi3b" = {
          id = "3WU2KZJ-FZHIYKV-IYPPGST-WA77JLU-FQ2L5YW-7HQYOLA-LXMVEL7-VIXZMAD";
          autoAcceptFolders = true;
        };
      };
    };
    openDefaultPorts = true;
  };
}
