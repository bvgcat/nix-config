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
    databaseDir = "/home/${user}/syncthing";
    guiAddress = "[::]:" + toString port;
    settings = {
      devices = {
        "XQ-DC54" = {
          id = "C6BH2I7-UX4FGTM-7RFN4ZN-QQXOTU2-BFZOL7C-PS2I43T-QB5HBWG-R3OB3A5";
          autoAcceptFolders = true;
        };
        "nixos@latitude-5290" = {
          id = "NG5MYM5-FAWXKH4-7CUGTQM-LAUFPXE-NRPTDG5-TLKNHLC-47BOMEY-W7TE4AM";
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

  networking.firewall.allowedTCPPorts = [ port ];
}
