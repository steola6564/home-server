{ pkgs, lib, inputs, ...}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers = {
      vanilla-plugin-server = {
        enable = true;
        package = pkgs.paperServers.paper-1_21_1;

	whitelist = {};
	serverProperties = {
	  # Port
          server-port = 25565;

	  # game mode
	  gamemode = "survival"; # survival / creative / adventure / spectator
	  difficulty = "normal"; # peaceful / easy / normal / hard

	  # chest
	  enable-command-block = true;
	  allow-flight = true;
	  spawn-protection = 0;

	  # multi
	  online-mode = true;
	  max-players = 20;

	  # world
	  level-name = "niboland";
	  level-seed = "8112500777490990468";
	  view-distance = 10;
	  simulation-distance = 10;
	  
	  # other
	  pvp = true;
	  motd = "NixOS Paper Server";
        };
      };
    };
  };
}
