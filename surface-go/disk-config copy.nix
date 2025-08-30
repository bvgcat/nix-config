# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#  imports = [ ./disko-config.nix ];
#  disko.devices.disk.main.device = "/dev/sda";
# }
# https://gist.github.com/Kidsan/d61ecaabc971569e9f915e62732ccc54 check this for zfs at some point
# https://github.com/nix-community/disko-templates/blob/main/zfs-impermanence/disko-config.nix
{
  user,
  ...
}:

{
  disko.devices = {
    disk = {
      root = {
        device = "/dev/mmcblk0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                # LUKS passphrase will be prompted interactively only
                type = "luks";
                name = "root";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
      sdcard = {
        device = "/dev/mmcblk1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            sdcard = {
              size = "100%";
              content = {
                # LUKS passphrase will be prompted interactively only
                type = "luks";
                name = "sdcard";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/run/media/${user}/sdcard";
                  mountOptions = [ "rw" "relatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
