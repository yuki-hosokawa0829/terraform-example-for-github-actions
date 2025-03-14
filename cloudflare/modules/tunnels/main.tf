terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
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

# Creates the CNAME record that routes www.${var.prefix}.${var.domain_name} to the tunnel.
resource "cloudflare_record" "cname" {
  count   = var.prefix == "dev" || var.prefix == "stg" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "www.${var.prefix}"
  value   = cloudflare_tunnel.auto_tunnel.cname
  type    = "CNAME"
  proxied = true
}

# Creates the CNAME record that routes www.${var.domain_name} to the tunnel.
resource "cloudflare_record" "cname_prod" {
  count   = var.prefix == "prd" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "www.${var.prefix}"
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
      hostname = cloudflare_record.cname[count.index].hostname
      service  = "http://${var.cluster_ip}" # The private IP address of the AKS cluster
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
      hostname = cloudflare_record.cname_prod[count.index].hostname
      service  = "http://${var.cluster_ip}" # The private IP address of the AKS cluster
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

resource "cloudflare_load_balancer" "lb" {
  zone_id          = var.cloudflare_zone_id
  name             = "www.${var.environment}.${var.domain_name}"
  fallback_pool_id = cloudflare_load_balancer_pool.lbp.id
  default_pool_ids = [cloudflare_load_balancer_pool.lbp.id]
  proxied          = true
  steering_policy  = "random"

  #rules {
  #  name      = "lbp rule"
  #  condition = "http.request.uri.path contains \"testing\""
  #  fixed_response {
  #    message_body = "hello"
  #    status_code  = 200
  #    content_type = "html"
  #    location     = "www.lbp.com"
  #  }
  #}
}

resource "cloudflare_load_balancer_pool" "lbp" {
  account_id = var.cloudflare_account_id
  name       = "lbp-${var.environment}"
  origins {
    name    = "server-1"
    address = cloudflare_tunnel.auto_tunnel.cname
    enabled = true
  }
}