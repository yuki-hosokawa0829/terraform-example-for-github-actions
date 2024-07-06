terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
  }
}

# Generates a 64-character secret for the tunnel.
# Using `random_password` means the result is treated as sensitive and, thus,
# not displayed in console output. Refer to: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "tunnel_secret" {
  length = 64
}

# Creates a new locally-managed tunnel for the AKS.
resource "cloudflare_tunnel" "auto_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "Terraform AKS tunnel ${var.environment}"
  secret     = base64sha256(random_password.tunnel_secret.result)
}

output "secret" {
  value = cloudflare_tunnel.auto_tunnel.secret
}

# Creates the CNAME record that routes www.${var.prefix}.${var.domain_name} to the tunnel.
resource "cloudflare_record" "cname" {
  count   = var.prefix == "dev" || var.prefix == "stg" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "www.${var.prefix}.${var.environment}"
  value   = cloudflare_tunnel.auto_tunnel.cname
  type    = "CNAME"
  proxied = true
}

# Creates the CNAME record that routes www.${var.domain_name} to the tunnel.
resource "cloudflare_record" "cname_prod" {
  count   = var.prefix == "prd" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "www.${var.environment}"
  value   = cloudflare_tunnel.auto_tunnel.cname
  type    = "CNAME"
  proxied = true
}

# Creates the configuration for the tunnel.
resource "cloudflare_tunnel_config" "auto_tunnel" {
  count      = var.prefix == "dev" || var.prefix == "stg" ? 1 : 0
  tunnel_id  = cloudflare_tunnel.auto_tunnel.id
  account_id = var.cloudflare_account_id
  config {
    ingress_rule {
      hostname = cloudflare_record.http_app.hostname
      service  = "https://www.${var.prefix}.${var.domain_name}"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Creates the configuration for the tunnel.
resource "cloudflare_tunnel_config" "auto_tunnel_prod" {
  count      = var.prefix == "prd" ? 1 : 0
  tunnel_id  = cloudflare_tunnel.auto_tunnel.id
  account_id = var.cloudflare_account_id
  config {
    ingress_rule {
      hostname = cloudflare_record.http_app.hostname
      service  = "https://www.${var.domain_name}"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}