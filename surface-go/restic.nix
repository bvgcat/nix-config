{ config, pkgs, user, ... }:

{
  services.restic.backups.tubcloud = {
    initialize = true;
    repository = "rest:https://tubcloud.tu-berlin.de/remote.php/webdav/backups";
    passwordFile = config.sops.secrets.restic-password.path;
    environmentFile = config.sops.secrets.restic-env.path;
    paths = [ "/home/${user}" "/run/media/${user}/sdcard" ];

    # Run daily
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };

    # Auto-prune old snapshots
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };

  environment.systemPackages = with pkgs; [ backrest nodejs];
  environment.variables = {
    #BACKREST_CONFIG = "";
    #BACKREST_DATA = "";
    BACKREST_PORT = "localhost:9898";
    BACKREST_RESTIC_COMMAND = "${pkgs.restic}/bin/restic";
  };

  systemd.user.units.backrest-gui.service = {
    description = "Backrest Web GUI for Restic";

    serviceConfig = {
      ExecStart = "${pkgs.backrest}/bin/backrest gui --port 9898";
      EnvironmentFile = config.sops.secrets.restic-env.path;
      Environment = "
        RESTIC_PASSWORD_FILE=${config.sops.secrets.restic-password.path}
        RESTIC_REPOSITORY=rest:https://tubcloud.tu-berlin.de/remote.php/webdav/backups
      ";
      Restart = "always";
    };

    wantedBy = [ "default.target" ];
  };
}
