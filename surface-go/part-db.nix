{ config, pkgs, lib, ... }:

{
  users.groups.part-db = {};
  # Ensure user exists
  users.users.part-db = {
    isSystemUser = true;
    group = "part-db";
    createHome = true;
    home = "/home/part-db";
    packages = with pkgs; [
      part-db
    ];	
    openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINej8Vqt3lEBNDErxejC1ADYDehGVLWjMgJ/ANFE+U+k nixos@latitude-5290"
    ];
  };

  systemd.services.part-db = {
    description = "PartDB PHP Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      User = "part-db";
      Group = "part-db";
      WorkingDirectory = "${pkgs.part-db}";  # Adjust if needed
      ExecStart = "${pkgs.part-db}/bin/phpunit -d memory_limit=256M ${pkgs.part-db}/bin/console server:run 0.0.0.0:5432";
      Restart = "always";
      ProtectSystem = "full";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };

  services.part-db = {
    enable = true;
    package = pkgs.part-db;
    enablePostgresql = true;

    settings = {
      DATABASE_URL = "postgresql://part-db:password@127.0.0.1:5432/part-db?serverVersion=17.4&charset=utf8";
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;  # Explicitly specify version 17
    ensureDatabases = [ "part-db" ];
    ensureUsers = [
      {
        name = "part-db";
        ensureDBOwnership = true;
      }
    ];
    enableTCPIP = true;
    
    authentication = ''
      # type  database DBuser   origin-address  auth-method
      local   all      all                      peer
      host    part-db   part-db   127.0.0.1/32    scram-sha-256
      host    part-db   part-db   ::1/128         scram-sha-256
    '';

    initialScript = pkgs.writeText "postgres-init-script" ''
      CREATE ROLE "part-db" WITH LOGIN PASSWORD 'password';
      CREATE DATABASE "part-db" OWNER "part-db";
      GRANT ALL PRIVILEGES ON DATABASE "part-db" TO "part-db";
    '';
  };
}