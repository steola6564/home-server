{ pkgs, ... }:
{
  programs.mtr.enable = true;
  environment.systemPackages = with pkgs; [
    vim wget neovim git gh htop tmux curl
    cloudflared-bin terraform #opentofu
    tailscale headscale
    home-manager
  ];
}

