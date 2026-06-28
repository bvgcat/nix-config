{
  inputs = {
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-26.05-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/a9cf7546a938c737b079e738de73934a13de9784";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
  {
    nixpkgs-old,
    nixpkgs,
    nixpkgs-small,
    nixpkgs-unstable,
    disko,
    nixos-hardware,
    sops-nix,
    ...
  }:
  {
    formatter = nixpkgs.nixfmt;
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
        ./secrets/sops.nix
        ./modules
        ./modules/settings.nix
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
        ./secrets/sops.nix
        ./modules
        ./modules/common.nix
        ./modules/settings.nix
        ./modules/settings.nix
      ];
    };

    nixosConfigurations.thinkpad-l14-g2 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ ... }: {
          _module.args = {
            user = "h";
            hostname = "thinkpad-l14-g2";
            nixpkgs-old = nixpkgs-old;
          };
        })
        nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
        sops-nix.nixosModules.sops
        ./thinkpad-l14-g2
        ./secrets/sops.nix
        ./modules
        ./modules/settings.nix
        ./modules/common.nix
      ];
    };

    nixosConfigurations.pi3b = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # build machine (ThinkPad / homeserver)

      modules = [
        ({ ... }: {
          _module.args = {
            user = "m";
            hostname = "pi3b";
          };
          nixpkgs.hostPlatform = "aarch64-linux";
        })
        nixos-hardware.nixosModules.raspberry-pi-3
        sops-nix.nixosModules.sops
        ./pi3b
        ./secrets/sops.nix
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
        ./secrets/sops.nix
        ./modules
        ./modules/common.nix
        ./modules/settings.nix
      ];
    };
  };
}
