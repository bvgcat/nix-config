{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [

	];

	users.users.user.packages = with pkgs; [
		firefox
		spotify  
		syncthing
	];	

  # make systemd service start automatically
	services.syncthing = {
		enable = true;
		configDir = "/home/user/.config/syncthing";
		user = "user";
	};
	networking.firewall.allowedTCPPorts = [ 8384 22000 ];
	networking.firewall.allowedUDPPorts = [ 21027 22000 ];
}