{
  modulesPath,
  lib,
  pkgs,
  ...
}:

let
  hostname = "homeserver";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./surface-go/nextcloud.nix
  ];

  sops.secrets.duckdns = {
    sopsFile = ./secrets/secrets.yaml;
  };

  networking.hostName = "${hostname}"; # Define your hostname.

  services = {
    displayManager = {
      sddm.enable = true;
      autoLogin.enable = true;
      sddm.autoLogin.relogin = true;
      autoLogin.user = "${hostname}";
    };
    desktopManager.plasma6.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.godns = {
    enable = true;
    settings = {
      provider = "DuckDNS";
      login_token = config.sops.secrets.duckdns;
      domains = [
        {
          domain_name = "duckdns.org";
          sub_domains = [ "hs-bvgcat" ];
        }
      ];
      resolver = "1.1.1.1";
      ip_urls = [ "https://api.ip.sb/ip" ];
      ip_type = "IPv4";
      interval = 3000;
    };
  };
  services.openssh.enable = true;
  boot.initrd.network.ssh.enable = true;
  systemd = {
    services = {
      NetworkManager = {
        wantedBy = [ "multi-user.target" ];
      };
      suspend = {
        enable = false;
      };
    };
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
    ];
    ${hostname} = {
      isNormalUser = true;
      uid = 1000;
      group = "users";
      password = "";
      openssh.authorizedKeys.keys = [
        # change this to your ssh key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    certbot-full
    git
    libsForQt5.kamoso
  ];
  programs.kdeconnect.enable = true;

  boot.kernelModules = [ "snd_hda_intel" ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  system.stateVersion = "24.11";
}
