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
        package = pkgs.vanillaServers.vanilla-1_21_1;

        serverProperties = {};
	whitelist = {};
	serverProperties = {
          server-port = 25565;
        };
      };
    };
  };
}
