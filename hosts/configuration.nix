{ inputs, lib, pkgs, ... }: {
  imports = [

    # Hardware
    ./hardware-configuration.nix

    # Boot
    ../modules/system/base.nix
    ../modules/system/boot.nix

    # Service
    ../modules/services/common.nix
    ../modules/services/ssh.nix
    # ../modules/services/nextcloud.nix
    ../modules/services/cloudflared.nix
    ../modules/services/minecraft.nix
    ../modules/services/headscale.nix
    ../modules/networking/tailscale.nix
    ../modules/services/proxmox.nix

    # User
    ../modules/users/steola.nix
    ../modules/users/cloudflared.nix

    # ops
    ../modules/pkgs.nix
    ../modules/ops/agenix.nix
    ../modules/ops/terraform.nix
  ];

  networking.hostName = "nixos-server";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.stateVersion = "25.05";
}

