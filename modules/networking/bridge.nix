{ config, lib, pkgs, ... }:

{
  networking = {
    bridges.vmbr0 = {
      interfaces = [ "eno1" ];
    };

    interfaces = {
      vmbr0.useDHCP = true;
      eno1.useDHCP  = false;
    };
  };

  networking.firewall.trustedInterfaces = [ "vmbr0" ];
}

