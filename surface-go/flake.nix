{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs =
    {
      nixpkgs,
      disko,
      nixos-hardware,
      ...
    }:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#surface-go --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations.surface-go = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.microsoft-surface-go
          ./surface-go.nix
          ./disk-config.nix
          ./hardware-configuration.nix
        ];
      };
    };
}
