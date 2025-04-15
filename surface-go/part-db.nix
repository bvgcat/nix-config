{ config, pkgs, lib, ... }:

{
  services.part-db = {
    enable = true;
    package = pkgs.part-db;
    enablePostgresql = true;

    settings = {
      # DATABASE_URL="postgresql://db_user@localhost/db_name?serverVersion=16.6&charset=utf8&host=/var/run/postgresql"
      DATABASE_URL = "postgresql://part-db@localhost/part-db?serverVersion=17.4&charset=utf8&host=/var/run/postgresql";
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;

    authentication = ''
      # type  database  DBuser    origin-address  auth-method
      local   all       all                       peer
      host    part-db   part-db   127.0.0.1/32    scram-sha-256
      host    part-db   part-db   ::1/128         scram-sha-256
    '';
  };

  # allow the ports used for php through
	networking.firewall.allowedTCPPorts = [ 80 ];
	networking.firewall.allowedUDPPorts = [ 80 ];
}