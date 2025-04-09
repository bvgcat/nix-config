{ config, pkgs, lib, ... }:

{
  services.part-db = {
    enable = true;
    package = pkgs.part-db;
    settings = {
      DATABASE_URL="postgresql://surface-go:password@127.0.0.1:5432/part-db?serverVersion=12.19&charset=utf8";
    };
  };

  config.services.postgresql = {
    enable = true;
    ensureDatabases = [ "part-db" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };
}