terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4.3.0"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = var.backend_endpoint
    }
    bucket                      = var.backend_bucket
    key                         = var.backend_key
    region                      = var.backend_region
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}



provider "cloudflare" {
  #api_token = var.cloudflare_account_id
}

module "cloudflare_tunnel" {
  source                = "../../modules/tunnels"
  environment           = var.environment
  cloudflare_zone_id    = var.cloudflare_zone_id
  cloudflare_account_id = var.cloudflare_account_id
}