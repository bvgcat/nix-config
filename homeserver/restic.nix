{ config, pkgs, user, ... }:

let 
  repo_path = "/run/media/${user}/trans_ext4/homeserver";
in 
{
  # Restic backup service
  services.restic.backups.local_ssd = {
    initialize = true;
    repository = repo_path;
    passwordFile = config.sops.secrets.restic-password.path;
    paths = [ "/home/${user}" "/run/media/${user}/sdcard" ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };

  # System packages for Backrest
  environment.systemPackages = with pkgs; [ backrest nodejs restic ];

  # Environment variables for Backrest
  environment.variables = {
    BACKREST_PORT = "localhost:9898";
    BACKREST_RESTIC_COMMAND = "${pkgs.restic}/bin/restic";
  };

  systemd.services.backrest-gui = {
    description = "Backrest Web GUI for Restic";
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.backrest}/bin/backrest gui --port 9898";
      User = "${user}";
      WorkingDirectory = "/home/${user}";
      Environment = ''
        RESTIC_PASSWORD_FILE=${config.sops.secrets.restic-password.path}
        RESTIC_REPOSITORY=${repo_path}
        HOME=/home/${user}
      '';
      Restart = "always";
    };

    wantedBy = [ "multi-user.target" ];
  };
}

