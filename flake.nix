{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-24.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      nixpkgs,
      disko,
      nixos-hardware,
      nixpkgs-24,
      sops-nix,
      #nix-config,
      ...
    }:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#partdb-terminal --generate-hardware-config nixos-generate-config ./surface-go/hardware-configuration.nix nixos@192.168.0.4
      nixosConfigurations.homeserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (
            { ... }:
            {
              _module.args = {
                user = "homeserver";
              };
            }
          )
          #nixos-hardware.nixosModules.microsoft-surface-go
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          ./secrets/sops.nix
          ./surface-go/disk-config.nix
          ./surface-go/duckdns.nix
          ./surface-go/hardware-configuration.nix
          ./surface-go/homepage-dashboard.nix
          ./surface-go/immich.nix
          ./surface-go/nextcloud.nix
          ./surface-go/nginx.nix
          ./surface-go/spotify.nix
          ./surface-go/syncthing.nix
          ./surface-go.nix
          ./modules/bash.nix
          ./modules/default.nix
        ];
      };

      nixosConfigurations.legion-5 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-legion-15arh05h
          sops-nix.nixosModules.sops
          ./legion-5/hardware-configuration.nix
          ./legion-5.nix
          ./modules/bash.nix
          ./modules/default.nix
          ./modules/common.nix
        ];
      };

      nixosConfigurations.latitude-5290 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          #nixos-hardware.nixosModules.dell-latitude-5490
          sops-nix.nixosModules.sops
          ./latitude-5290/hardware-configuration.nix
          ./latitude-5290.nix
          ./modules/bash.nix
          ./modules/default.nix
          ./modules/common.nix
        ];
      };
    };
}
