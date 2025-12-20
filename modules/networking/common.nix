{ config, lib, pkgs, ... }:
{
  networking.networkmanager.enable = true;
  # networking.firewall.allowedTCPPorts = [ 25565 ];

}
