{ config, lib, pkgs, ... }:

{
  networking = {
    
    useNetworkd = true;
    useDHCP = false;

    bridges.vmbr0 = {
      interfaces = [ "eno1" ];
    };

    interfaces = {
      vmbr0.useDHCP = true;
      eno1.useDHCP  = false;
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };

  networking.firewall.trustedInterfaces = [ "vmbr0" ];
 
  networking.dhcpcd.enable = false;
}

