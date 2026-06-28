{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/9bd7c80d43e258aaa607d83b43661df11444d808";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, nixos-hardware, sops-nix, ... }:
  let
    system = "aarch64-linux";
  in {
    nixosConfigurations.pi3b = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [        
        ({ ... }: {
          _module.args = {
            user = "m";
            hostname = "pi3b";
          };
          nixpkgs .hostPlatform = system;
          boot.loader.grub.enable = false;
          boot.loader.generic-extlinux-compatible.enable = true;
          services.openssh.enable = true;
          boot.kernelParams = [
            "console=ttyAMA0,115200"
            "console=tty1"
          ];
          sdImage.compressImage = false;
        })
        nixos-hardware.nixosModules.raspberry-pi-3
        sops-nix.nixosModules.sops
        ./default.nix
        ../secrets/sops.nix
        ../modules


        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ];
    };
  };
}