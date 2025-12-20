{
  description = "NixOS/Darwin unified repo (方案A)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, unstable, home-manager, agenix, vscode-extensions, nvfetcher, flake-utils, ... }:
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

    homeManagerModules = {
      default =
        { config, lib, pkgs, username, homeDirectory, ... }:
        {
          imports = [
            ./modules/home/home.nix
          ];

          home.username = username;
          home.homeDirectory = homeDirectory;
          home.stateVersion = "25.05";
        };
    };

    overlays = {
        default = import ./overlays/cloudflared.nix;
    };

    nixosConfigurations.nixos-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
	hostname = "nixos-server";
      };  # modules/ops/agenix.nix で使う
      modules = [
        ./hosts/nixos-server/configuration.nix
        home-manager.nixosModules.home-manager

        # overlay を有効化 + unfree許可維持
        ({ pkgs, ... }: {
          nixpkgs = {
            overlays = [ self.overlays.default ];
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

