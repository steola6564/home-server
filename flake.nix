{
  description = "Home server NixOS flake for self-hosted services (Nextcloud, Minecraft, etc.)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-25_11.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

    nix-cloudflared.url = "github:steola6564/nix-cloudflared";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    headscale.url = "github:juanfont/headscale";
    agenix.url = "github:ryantm/agenix";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:steola6564/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, unstable, proxmox-nixos, home-manager, agenix, dotfiles, nix-cloudflared, flake-utils, ... }:
  {   

    nixosConfigurations.nixos-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
	hostname = "nixos-server";
      };  # modules/ops/agenix.nix で使う
      modules = [
        ./hosts/nixos-server/configuration.nix
	proxmox-nixos.nixosModules.proxmox-ve

        # overlay を有効化 + unfree許可維持
        ({ pkgs, system, inputs, ... }: {
          nixpkgs = {
            overlays = [
	      proxmox-nixos.overlays.x86_64-linux

	      (final: prev: {
	        tailscale = 
		  inputs.nixpkgs-25_11.legacyPackages.${final.system}.tailscale;
		headscale =
		  inputs.nixpkgs-25_11.legacyPackages.${final.system}.headscale;
	      })
	      inputs.nix-cloudflared.overlays.default
	      inputs.nix-minecraft.overlay
	    ];
            config = {
              allowUnfree = true;
              # 元の意図：terraform と cloudflared-bin を許可
              allowUnfreePredicate = pkg:
                builtins.elem (pkgs.lib.getName pkg) [ "terraform" "cloudflared-bin" ];
            };
          };
        })
      ];
    };

    nixosConfigurations.minecraft = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
        hostname = "minecraft";
      };

      modules = [
        ./hosts/minecraft/configuration.nix

        # Minecraft module が inputs を使うため
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            inputs.nix-minecraft.overlay
          ];
        })
      ];
    };
    nixosConfigurations.minecraft = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
        hostname = "vps";
      };

      modules = [
        ./hosts/vps/configuration.nix

        # Minecraft module が inputs を使うため
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            inputs.nix-minecraft.overlay
          ];
        })
      ];
    };


  };
}

