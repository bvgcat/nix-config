{ config, pkgs, lib, ... }:

{
  services.part-db = {
    enable = true;
    package = pkgs.part-db;
    settings = {
      DATABASE_URL="postgresql://surface-go:password@127.0.0.1:5432/FaST-PARTDB?serverVersion=12.19&charset=utf8";
    };
  };
}