{
  user,
  pkgs,
  ...
}:

{
  imports = [
    ../secrets/sops.nix

    ./networking.nix
    ./ssh.nix
    ./syncthing.nix
  ];
  
  sops = {
    age.keyFile = "/var/lib/sops/key.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  environment.systemPackages = with pkgs; [
    age
    sops
    curl
    git
    gnupg
    htop
    openssl
    pciutils
    powertop
    qdirstat
    usbutils
    wireguard-tools
  ];
  
  programs.bash.shellAliases = {
    rkde = "kstart5 plasmashell";
    clean = "sudo nix-collect-garbage -v -d && sudo nix-store -v --gc && sudo nix-store -v --optimise";
  };
}