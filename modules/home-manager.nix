{ inputs, config, lib, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.steola = {
      imports = [
        inputs.dotfiles.homeManagerModules.default
      ];
    };

    extraSpecialArgs = {
      username = "steola";
      homeDirectory = "/home/steola";
    };
  };
}

