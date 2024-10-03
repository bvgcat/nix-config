{ config, pkgs, lib, ... }:

{	
  imports = [ 
    ./nixos-hardware/microsoft/surface/surface-go/default.nix # surface go hardware
	];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.cleanTmpDir = true;

	environment.systemPackages = with pkgs; [
		gnome.gnome-tweaks
		gnomeExtensions.appindicator
		gnomeExtensions.gsconnect	
		gnomeExtensions.net-speed-simplified
	];
	
  users.users.h = {
		packages = with pkgs; [
			#tor-browser
		];
	};
    
  swapDevices = [ 
  #  { device = "/swapfile"; size = 8*1024;} 
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
