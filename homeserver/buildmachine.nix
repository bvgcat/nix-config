{ ... }:
{
  user = "builder";
  imports = [ ../modules/ssh.nix ];
  users.users = {
    builder = {
      isNormalUser = true;
      description = "Remote Nix builder";
      createHome = false;
      extraGroups = [ "wheel" ];
    };
  };
}