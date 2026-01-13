{ pkgs, ... }:
{
  programs.mtr.enable = true;
  environment.systemPackages = with pkgs; [
    vim wget neovim git gh htop tmux curl
    tailscale headscale
    home-manager
  ];
}

