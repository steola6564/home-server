{ config, lib, pkgs, ... }:
{
  networking.networkmanager.enable = false;
  # networking.firewall.allowedTCPPorts = [ 25565 ];

  # services.headscale.address = "0.0.0.0";
  # services.headscale.port = 443;

  # networking.firewall.allowedTCPPorts = [ 443 ];
}
