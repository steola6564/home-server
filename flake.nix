{
  description = "Home server NixOS flake for self-hosted services (Nextcloud, Minecraft, etc.)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    nix-cloudflared.url = "github:steola6564/nix-cloudflared";

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

  outputs = inputs @ { self, nixpkgs, unstable, home-manager, agenix, dotfiles, nix-cloudflared, flake-utils, ... }:
  {   

    nixosConfigurations.nixos-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
	hostname = "nixos-server";
      };  # modules/ops/agenix.nix で使う
      modules = [
        ./hosts/configuration.nix
        home-manager.nixosModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.steola = {
	    imports = [
	      dotfiles.homeManagerModules.default
	    ];
	  };
	  home-manager.extraSpecialArgs = {
	    username = "steola";
	    homeDirectory = "/home/steola";
	  };
	}

        # overlay を有効化 + unfree許可維持
        ({ pkgs, ... }: {
          nixpkgs = {
            overlays = [ inputs.nix-cloudflared.overlays.default ];
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
  };
}

