{ pkgs, lib, inputs, ...}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      vanila-plugin-server = {
        enable = true;

	serverProperties = {};
	whitelist = {};
      };
    };
  };
}
