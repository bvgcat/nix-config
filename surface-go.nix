{
  modulesPath,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking.hostName = "homeserver"; # Define your hostname.

  services = {
    displayManager = {
      sddm.enable = false;
      autoLogin.enable = true;
      autoLogin.user = "homeserver";
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
    partdb-terminal = {
      isNormalUser = true;
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

  boot.kernelModules = [ "snd_hda_intel" ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  system.stateVersion = "24.11";
}
