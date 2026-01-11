############################################
# DNS: proxmox.niboratory.com
############################################
resource "cloudflare_record" "proxmox" {
  zone_id = var.cloudflare_zone_id
  name    = "proxmox"
  type    = "CNAME"
  content = "${var.tunnel_id}.cfargotunnel.com"
  proxied = true
  comment = "Proxmox Web UI via Cloudflare Tunnel"
}

############################################
# Zero Trust Access Application
############################################
resource "cloudflare_zero_trust_access_application" "proxmox" {
  account_id       = var.cloudflare_account_id
  name             = "proxmox-web-ui"
  domain           = "proxmox.niboratory.com"
  session_duration = "24h"
  type             = "self_hosted"
}

############################################
# Allow only you
############################################
resource "cloudflare_zero_trust_access_policy" "proxmox_allow_me" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_zero_trust_access_application.proxmox.id

  name       = "allow-myself"
  precedence = 1
  decision   = "allow"

  include {
    email = [var.allow_email]
  }
}

############################################
# Default deny
############################################
resource "cloudflare_zero_trust_access_policy" "proxmox_default_deny" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_zero_trust_access_application.proxmox.id

  name       = "default-deny"
  precedence = 1000
  decision   = "deny"

  include {
    everyone = true
  }
}

