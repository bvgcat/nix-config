{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    curl
    git
    openssl
  ];
  
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true;
  
  system.autoUpgrade = {
    enable = true;
    operation = "switch";
    flake = "github:bvgcat/nix-config";
    dates = "Sat *-*-* 2:00:00";
  };

  security.rtkit.enable = true;
  systemd = {
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  programs.kdeconnect.enable = true;

  users.groups.services = {};

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [
        "homeserver:21gbBImd72iH+aKAxOXZXzj8fkTGrMtlxiL4SSzHgoY="
      ];
    };
    extraOptions = ''
      secret-key-files = /etc/nix/homeserver
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";  # base locale (for LANG)
  i18n.extraLocaleSettings = {
    LC_CTYPE = "de_DE.UTF-8";
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";  # Keep messages in English
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
    LC_COLLATE = "de_DE.UTF-8";
  };
}