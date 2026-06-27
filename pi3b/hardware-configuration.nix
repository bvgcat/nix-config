{ lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];


  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
  
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
  };
  
  fileSystems."/" =
  { 
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];
}