{
  user,
  pkgs,
  ...
}:

{
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "homeserver";
        sshUser = "builder";
        sshKey = "/root/.ssh/id_ed25519";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 8;
        supportedFeatures = [
          "kvm"
          "big-parallel"
        ];
      }
    ];
    settings = {
      trusted-users = [ user ];
      builders-use-substitutes = true;
    };
  };
}
