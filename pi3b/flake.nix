
  {
  outputs = { self, nixpkgs, ... }:
  let
    system = "aarch64-linux";
  in {
    nixosConfigurations.rpi3 = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./default.nix
        ../modules/settings.nix
        ../modules/ssh.nix
        ../modules/syncthing.nix
        #./pi-hole.nix
        #./wireguard.nix
        ({ ... }: {
          nixpkgs .hostPlatform = system;
          boot.loader.grub.enable = false;
          boot.loader.generic-extlinux-compatible.enable = true;
          networking.hostName = "rpi3";
          services.openssh.enable = true;
          boot.kernelParams = [
            "console=ttyAMA0,115200"
            "console=tty1"
          ];
          sdImage.compressImage = false;
        })

        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ];
    };
  };
}