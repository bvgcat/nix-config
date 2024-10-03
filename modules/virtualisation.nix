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
    boot = {
      initrd.kernelModules = [ "kvm-${platform}" "vfio_pci" "vfio_iommu_type1" "vfio" ];
      kernelParams = [ "${platform}_iommu=on" "${platform}_iommu=pt" "kvm.ignore_msrs=1" "nvidia" "snd_hda_intel" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "pcie_acs_override=downstream"] 
      ++ lib.optional cfg.enable ("vfio-pci.ids=" + lib.concatStringsSep "," vfioIds);
    };

    hardware.opengl.enable = true;

    users.users.${user}.extraGroups = [ "libvirtd" ];

    virtualisation = with pkgs; {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        extraConfig = ''
          uri_default = "qemu:///system"
        '';
        qemu = {
          package = qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf.enable = true;
        };

        # Don't start any VMs automatically on boot.
        onBoot = "ignore";
        # Stop all running VMs on shutdown.
        onShutdown = "shutdown";
      };
    };
  };
}