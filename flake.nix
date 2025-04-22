{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #nix-config.url = "github:bvgcat/nix-config";
  };

  outputs =
    {
      nixpkgs,
      disko,
      nixos-hardware,
      #nix-config,
      ...
    }:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#surface-go --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations.partdb-terminal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.microsoft-surface-go
          ./surface-go/hardware-configuration.nix
          ./surface-go.nix
          ./modules/bash.nix
          ./modules/default.nix
          ./surface-go/part-db.nix
        ];
      };

      nixosConfigurations.legion-5 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-legion-15arh05h
          ./legion-5/hardware-configuration.nix
          ./legion-5.nix
          ./modules/bash.nix
          ./modules/common.nix
          ./modules/default.nix
        ];
      };

        nixosConfigurations.latitude-5290 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.dell-latitude-5490
          ./latitude-5290/hardware-configuration.nix
          ./latitude-5290.nix
          ./modules/bash.nix
          ./modules/default.nix
          ./modules/common.nix
        ];
      };
    };
}
