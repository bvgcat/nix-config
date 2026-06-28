{
  user,
  ...
}:

{
  imports = [
    ../secrets/sops.nix

    ./bash.nix
    ./networking.nix
    ./ssh.nix
    ./syncthing.nix
  ];

  nix.buildMachines = [
    {
      hostName = "homeserver";
      sshUser = "builder";
      sshKey = "/home/${user};/.ssh/id_ed25519";
      system = "x86_64-linux";
      maxJobs = 8;
      supportedFeatures = [ "kvm" "big-parallel" ];
    }
  ];
}