{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-master,
      disko,
      nixos-hardware,
      sops-nix,
      #nix-config,
      ...
    }:
    {
      # Use this for all other targets
      # nixos-anywhere --flake ./nix-config#homeserver --generate-hardware-config nixos-generate-config ./surface-go/hardware-configuration.nix nixos@192.168.178.200
      nixosConfigurations.homeserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "homeserver";
              hostname = "homeserver";
              pkgs-master = import nixpkgs-master {
                system = "x86_64-linux";
              };
            };
          })
          #nixos-hardware.nixosModules.microsoft-surface-go
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          ./secrets/sops.nix
          ./surface-go/disk-config.nix
          ./surface-go/duckdns.nix
          ./surface-go/hardware-configuration.nix
          ./surface-go/homepage-dashboard.nix
          ./surface-go/immich.nix
          ./surface-go/networking.nix
          ./surface-go/nextcloud.nix
          ./surface-go/nginx.nix
          ./surface-go/restic.nix
          ./surface-go/spotify.nix
          ./surface-go/ssh.nix
          ./surface-go/syncthing.nix
          ./surface-go.nix
          ./modules/bash.nix
          ./modules/default.nix
        ];
      };

      nixosConfigurations.legion-5 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "h";
              pkgs-master = import nixpkgs-master {
                system = "x86_64-linux";
              };
            };
          })
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
          ({ ... }: {
            _module.args = {
              user = "h";
              pkgs-master = import nixpkgs-master {
                system = "x86_64-linux";
              };
            };
          })
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
