{
  pkgs,
  ...
}:

# You might want to view the list of all available server properties for the vanilla server. 
# https://minecraft.wiki/w/Server.properties#Keys
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    package = pkgs.minecraft-server;
    serverProperties = {
      server-port = 25565;
      difficulty = 3;
      gamemode = 0;
      enable-status = true;
      enable-query = true;
      max-players = 5;
      motd = "Charlottenburger Crafters";
      white-list = true;
      allow-cheats = true;
      status-heartbeat-interval = true;
    };
    jvmOpts = "-Xms2048M -Xmx4096M";
  };
}