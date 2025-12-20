{
  description = "NixOS/Darwin unified repo (方案A)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    nix-cloudflared.url = "github:steola6564/nix-cloudflared";

    agenix.url = "github:ryantm/agenix";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    dotfiles = {
      url = "github:steola6564/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, unstable, home-manager, agenix, dotfiles, vscode-extensions, nvfetcher, flake-utils, ... }:
  let
    inherit (nixpkgs.lib) nixosSystem;
  in
  (

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
	        config.allowUnfree = true;
        };
      in
      {
        # Apps
        apps = {
          nvfetcher = {
            type = "app";
            program = "${inputs.nvfetcher.packages.${system}.default}/bin/nvfetcher";
          };
        };
      }
    )
  )

  //{   

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

