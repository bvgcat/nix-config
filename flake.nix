{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-config.url = "github:bvgcat/nix-config";
  };

  outputs =
    {
      nixpkgs,
      disko,
      nixos-hardware,
      nix-config,
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
          nix-config
          ./surface-go/surface-go.nix
          ./surface-go/hardware-configuration.nix
        ];
      };
    };
}
