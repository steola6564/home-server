{ pkgs, lib, inputs, ...}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      vanilla-plugin-server = {
        enable = true;

	serverProperties = {};
	whitelist = {};
      };
    };
  };
}
