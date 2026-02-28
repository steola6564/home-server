{ config, lib, pkgs, ... }:

{
  services.proxmox-ve = {
    enable = true;

    # Web UI が bind する IP
    # LAN 内アクセス前提
    ipAddress = "192.168.1.17";

    # 初期は最小構成
    openFirewall = true;

    # bridge は後で定義（まず起動優先）
    bridges = [ "vmbr0" ];
  };

  # Proxmox Web UI
  networking.firewall.allowedTCPPorts = [ 8006 ];
}

