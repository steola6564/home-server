{ config, pkgs, lib, ... }:

{
  services.headscale = {
    enable = true;

    settings = {
      # フェーズ2では localhost 前提
      server_url = "http://127.0.0.1:8080";

      # 外部公開しない
      listen_addr = "127.0.0.1:8080";

      ip_prefixes = [
        "100.64.0.0/10"
      ];

      # 後で有効化する
      dns_config = {
        magic_dns = false;
      };

      # ACL は後フェーズ
      policy = null;
    };
  };
}

