{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cloudflared-bin terraform #opentofu
  ];
}
