{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system/base.nix
      ../../modules/system/boot.nix
      ../../modules/services/ssh.nix
      ../../modules/users/steola.nix
      ../../modules/networking/common.nix
      ../../modules/pkgs/common.nix
      ../../modules/home-manager.nix
      # ../../modules/services/minecraft.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "vps";
  system.stateVersion = "25.11";
}

