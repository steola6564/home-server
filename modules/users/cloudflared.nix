{ pkgs, ... }:
{
  users.groups.cloudflared = {};
  users.users.cloudflared = {
    isSystemUser = true;
    group        = "cloudflared";
    description  = "Cloudflared Service user";
  };
}
