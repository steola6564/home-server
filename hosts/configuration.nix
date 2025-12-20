{ inputs, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../modules/services/common.nix
    ../modules/services/ssh.nix
    ../modules/pkgs.nix
    ../modules/system/base.nix
    ../modules/system/boot.nix
    ../modules/system/cloudflared-service.nix
    # ../modules/services/nextcloud.nix
    ../modules/users/steola.nix
    ../modules/users/cloudflared.nix
    ../modules/ops/agenix.nix
    ../modules/ops/terraform.nix
    ../modules/ui/fonts.nix
  ];

  networking.hostName = "nixos-server";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.stateVersion = "25.05";
}

