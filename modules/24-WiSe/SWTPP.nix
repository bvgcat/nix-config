{ config, pkgs, lib, ... }:

let
	pkgs-24 = import <nixos-24.05> {};
	pkgs-unstable = import <nixos-unstable> {};
in {
  environment.systemPackages = with pkgs-24; [];

	users.users.h.packages = with pkgs-24; [
    eclipses.eclipse-java
    swiProlog
  ];
}