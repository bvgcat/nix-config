{ pkgs, lib, config, ... }:
let
  # Change this to your username.
  user = "h";
  # Change this to match your system's CPU.
  platform = "amd";
  # Change this to specify the IOMMU ids you wrote down earlier.
  vfioIds = [ "10de:1f99" "10de:10fa" ];
in {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = let
    cfg = config.vfio;
  in {
    #services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];

    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      kernelParams = [
        # enable IOMMU
        "${platform}_iommu=on"  
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," vfioIds);
    };
  };
}