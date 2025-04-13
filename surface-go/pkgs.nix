{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [

	];

	users.users.surface-go.packages = with pkgs; [
		firefox
		spotify  
		#syncthing
	];	

  # make systemd service start automatically
	#services.syncthing = {
	#	enable = true;
	#	configDir = "/home/surface-go/.config/syncthing";
	#	user = "surface-got";
	#};
	#networking.firewall.allowedTCPPorts = [ 8384 22000 ];
	#networking.firewall.allowedUDPPorts = [ 21027 22000 ];
}