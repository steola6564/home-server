{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system/base.nix
      ../../modules/system/boot.nix
      ../../modules/services/ssh.nix
      ../../modules/users/steola.nix
      ../../modules/pkgs.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "minecraft"; # Define your hostname.

  networking.networkmanager.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}

