terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4.3.0"
    }
  }

  backend "s3" {
    endpoints = {
      #s3 = "https://f4e8dc64b95dae079fcfb11157ea522a.r2.cloudflarestorage.com"
      s3 = var.backend_endpoint
    }
    #bucket                      = "r2-tfstate-dev"
    #key                         = "terraform.tfstate"
    #region                      = "us-east-1" # any region will do
    bucket                     = var.backend_bucket
    key                        = var.backend_key
    region                     = var.backend_region
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}



provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "cloudflare_tunnel" {
  source                = "../../modules/tunnels"
  environment           = var.environment
  cloudflare_zone_id    = var.cloudflare_zone_id
  cloudflare_account_id = var.cloudflare_account_id
}