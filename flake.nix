{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-25.11-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/321cb2173bc3a6a2ccb1d50dea2373950720efad";
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-tuberlin = {
      url = "git+https://git.tu-berlin.de/hamza.tmm/nixos-tuberlin.git";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-small,
      nixpkgs-unstable,
      disko,
      nixos-hardware,
      sops-nix,
      nixos-tuberlin,
      ...
    }:
    {
      # Use this for all other targets
      # nixos-anywhere --flake ./nix-config#homeserver --generate-hardware-config nixos-generate-config ./nix-config/homeserver/hardware-configuration.nix nixos@192.168.178.200
      nixosConfigurations.homeserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "homeserver";
              hostname = "homeserver";
            };
          })
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          ./homeserver
          ./modules
        ];
      };

      nixosConfigurations.legion-5 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "h";
              hostname = "legion-5";
            };
          })
          nixos-hardware.nixosModules.lenovo-legion-15arh05h
          sops-nix.nixosModules.sops
          ./legion-5
          ./modules
          ./modules/common.nix
        ];
      };

      nixosConfigurations.latitude-5290 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "h";
              hostname = "latitude-5290";
            };
          })
          nixos-hardware.nixosModules.dell-latitude-5490
          sops-nix.nixosModules.sops
          ./latitude-5290
          ./modules
          ./modules/common.nix
        ];
      };

      nixosConfigurations.surface-go = nixpkgs-small.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "m";
              hostname = "surface-go";
            };
          })
          nixos-hardware.nixosModules.microsoft-surface-go
          sops-nix.nixosModules.sops
          disko.nixosModules.disko  
          ./surface-go
          ./modules
          ./modules/common.nix
          (import "${nixos-tuberlin}/GEM.nix")
          #(import "${nixos-tuberlin}/SWTPP.nix")
        ];
      };

      nixosConfigurations.thinkpad-l14-g2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "h";
              hostname = "thinkpad-l14-g2";
            };
          })
          nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
          sops-nix.nixosModules.sops
          ./thinkpad-l14-g2
          ./modules
          ./modules/common.nix
          (import "${nixos-tuberlin}/BSPrak.nix")
          (import "${nixos-tuberlin}/GEM.nix")
          (import "${nixos-tuberlin}/SWTPP.nix")
        ];
      };
    };
}
