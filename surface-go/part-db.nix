{ config, pkgs, lib, ... }:

let
  virtualhost = "localhost";
in {
  # https://github.com/NixOS/nixpkgs/blob/31180a926e448a45fc371f1f37e5fbaefb4bbe12/nixos/modules/services/web-apps/part-db.nix#L25
  users.users.partdb-terminal.packages = with pkgs; [
    certbot-full
  ];

  #security.acme = {
  #  acceptTerms = true;
  #  defaults.email = "admin+acme@example.org";
  #  certs."mx1.example.org" = {
  #    dnsProvider = "inwx";
      # Supplying password files like this will make your credentials world-readable
      # in the Nix store. This is for demonstration purpose only, do not use this in production.
  #    environmentFile = "${pkgs.writeText "inwx-creds" ''
  #      INWX_USERNAME=xxxxxxxxxx
  #      INWX_PASSWORD=yyyyyyyyyy
  #    ''}";
  #  };
  #};

  services = {
    part-db = {
      enable = true;
      package = pkgs.part-db;
      enablePostgresql = true;

      settings = {
        # DATABASE_URL="postgresql://db_user@localhost/db_name?serverVersion=16.6&charset=utf8&host=/var/run/postgresql"
        DATABASE_URL = "postgresql://part-db@localhost/part-db?serverVersion=17.4&charset=utf8&host=/var/run/postgresql";
      };
      
      virtualHost = "${virtualhost}";
      # setting php-fpm.conf options
      #poolConfig = {};
    };

    postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    #dataDir = "";

    authentication = ''
      # type  database  DBuser    origin-address  auth-method
      local   all       all                       peer
      host    part-db   part-db   127.0.0.1/32    scram-sha-256
      host    part-db   part-db   ::1/128         scram-sha-256
    '';
    };

    postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 03:00:00";
      databases = [ "part-db" ];
      #location = "";
    };

    nginx = {
      enable = true;
      virtualHosts = {
        "${virtualhost}" = {
          #root = "${config.services.part-db.package}/public";
          serverName = "part-db.bvgcat.top";
          serverAliases = [ "part-db.bvgcat.top" "bvgcat.top" "149.233.47.61:8000" ];
          #forceSSL = true;
        };
      };
    };
  };
  # allow the ports used for php through
	networking.firewall.allowedTCPPorts = [ 80 443 ];
	networking.firewall.allowedUDPPorts = [ 80 443 ];
}