{ config, pkgs, lib, ... }:

{	
	environment.systemPackages = with pkgs; [
		gnome.gnome-tweaks
		gnomeExtensions.appindicator
		gnomeExtensions.gsconnect	
		gnomeExtensions.net-speed-simplified
	];
  
  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

}
