variable "environment" {
  description = "The environment to deploy to."
  type        = string
}

variable "cloudflare_api_token" {
  description = "API token for your Cloudflare account"
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
}