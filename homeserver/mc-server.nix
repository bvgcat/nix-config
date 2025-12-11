{
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
    whitelist = {
      # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
      #username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
      #username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
    };
    serverProperties = {
      server-port = 25565;
      difficulty = 3;
      gamemode = 1;
      max-players = 5;
      motd = "Charlottenburger Crafters";
      white-list = true;
      allow-cheats = true;
    };
    jvmOpts = "-Xms2048M -Xmx4096M";
  };
}