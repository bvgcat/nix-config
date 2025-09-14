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
              pkgs-master = import nixpkgs-master {
                system = "x86_64-linux";
              };
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
              pkgs-master = import nixpkgs-master {
                system = "x86_64-linux";
              };
            };
          })
          #nixos-hardware.nixosModules.dell-latitude-5490
          sops-nix.nixosModules.sops
          ./latitude-5290
          ./modules
          ./modules/common.nix
        ];
      };

      nixosConfigurations.surface-go = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "m";
              hostname = "surface-go";
              pkgs-master = import nixpkgs-master {
                system = "x86_64-linux";
              };
            };
          })
          #nixos-hardware.nixosModules.microsoft-surface-go
          sops-nix.nixosModules.sops
          disko.nixosModules.disko  
          ./surface-go
          ./modules
          ./modules/common.nix
        ];
      };

      nixosConfigurations.thinkpad-l14-g2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args = {
              user = "h";
              hostname = "thinkpad-l14-g2";
              pkgs-master = import nixpkgs-master {
                system = "x86_64-linux";
              };
            };
          })
          nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
          sops-nix.nixosModules.sops
          ./thinkpad-l14-g2
          ./modules
          ./modules/common.nix
        ];
      };
    };
}
