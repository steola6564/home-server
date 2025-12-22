############################################
# DNS: headscale.niboratory.com
############################################
resource "cloudflare_record" "headscale" {
  zone_id = var.cloudflare_zone_id
  name    = "headscale"
  type    = "CNAME"
  content = "${var.tunnel_id}.cfargotunnel.com"
  proxied = true
  comment = "Headscale via Cloudflare Tunnel (IaC managed)"
}

############################################
# Zero Trust Access Application (Headscale)
############################################
resource "cloudflare_zero_trust_access_application" "headscale" {
  account_id       = var.cloudflare_account_id
  name             = "headscale-control-plane"
  domain           = "headscale.niboratory.com"
  session_duration = "24h"
  type             = "self_hosted"

  # Headscale は API / CLI クライアントが使うので
  # Access を噛ませない場合は、この resource 自体を消してもOK
}

############################################
# Access Policy: allow only me
############################################
resource "cloudflare_zero_trust_access_policy" "headscale_allow_me" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_zero_trust_access_application.headscale.id

  name       = "allow-myself"
  precedence = 1
  decision   = "allow"

  include {
    email = [var.allow_email]
  }
}

############################################
# Access Policy: default deny
############################################
resource "cloudflare_zero_trust_access_policy" "headscale_default_deny" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_zero_trust_access_application.headscale.id

  name       = "default-deny"
  precedence = 1000
  decision   = "deny"

  include {
    everyone = true
  }
}

