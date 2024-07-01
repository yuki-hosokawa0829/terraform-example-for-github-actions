terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=2.0.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "cloudflare_tunnel" {
  source = "../../modules/tunnels"
  environment = var.environment
  cloudflare_zone_id = var.cloudflare_zone_id
  cloudflare_account_id = var.cloudflare_account_id
}