{ pkgs, ... }:
{
  programs.mtr.enable = true;
  environment.systemPackages = with pkgs; [
    vim wget neovim git gh htop curl cloudflared-bin terraform
    # opentofu
    home-manager
  ];
}

