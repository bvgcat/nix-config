{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking.hostName = "partdb-terminal"; # Define your hostname.

  services = {
    displayManager = {
      sddm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "partdb-terminal";
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

  systemd.services.suspend = {
    enable = false;
  };

  services.openssh.enable = true;
  boot.initrd.network.ssh.enable = true;
  systemd = {
    services = {
      NetworkManager = {
        wantedBy = [ "multi-user.target" ];
      };
      kiosk-firefox = {
        description = "Firefox in kiosk mode";
        wantedBy = [ "graphical.target" ];
        after = [ "graphical.target" ];
        
        serviceConfig = {
          ExecStart = "${pkgs.firefox}/bin/firefox -kiosk localhost";
          Restart = "on-failure";
          RestartSec = 5;
          User = "partdb-terminal"; # <- Change to your desired user
          Environment = [
            "MOZ_ENABLE_WAYLAND=1"
            "WAYLAND_DISPLAY=wayland-0"
            "XDG_RUNTIME_DIR=/run/user/1000" # ← very important
          ];
        };
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
    git
	];

	boot.kernelModules = [ "snd_hda_intel" ];

	swapDevices = [
    { device = "/swapfile"; size = 4*1024; }
  ];

  system.stateVersion = "24.11";
}
