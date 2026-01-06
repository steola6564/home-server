{ config, lib, pkgs, ... }:

{
  networking = {
    bridges.vmbr0 = {
      interfaces = [ "eno1" ];
    };

    interfaces = {
      vmbr0.ipv4.addresses = [{
        address = "192.168.0.13";
	prefixLength = 24;
      }];

      # useDHCP = true;
      eno1.useDHCP  = false;
    };

    defaultGateway = "192.168.0.1";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  networking.firewall.trustedInterfaces = [ "vmbr0" ];

  networking.dhcpcd.enable = false;
}

