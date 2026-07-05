{ ... }:

let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpoapLR32CmYTb7xjNPWEm9OzCnqSidPwZ6cBdq59e1 nixos@homeserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiPoFO8It22YQ9Vbp0sfLnP6+LKAUL2niAuYpaXSiLU nixos@legion-5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLEKUxvn8ftYTF0opH9Kesf1PAcerJXLsp3feSzxZeC nixos@thinkpad-l14-g2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEFVUaUD6qmIdaA1j+0sR7nadUqdMD5L8n1MMbdsMyD nixos@surface-go"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxm/hekk06/1veUx/0OXXzjWbE6RMV8M3bzNa4fmtmB nixos@pi3b"
  ];
in 
{
  users.users = {
    builder = {
      isNormalUser = true;
      description = "Remote Nix builder";
      createHome = true;
      extraGroups = [ ];
      openssh.authorizedKeys.keys = keys;
      shell = "/run/current-system/sw/bin/bash";
    };
  };
  nix.settings.trusted-users = [
    "builder"
  ];
}