variable "environment" {
  description = "The environment to deploy to."
  type        = string
}

variable "cloudflare_api_token" {
  description = "API token token for Cloudflare"
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

variable "domain_name" {
  description = "The domain name to use for the tunnel"
  type        = string
}

variable "cluster_ip" {
  description = "The private IP address of the AKS cluster"
  type        = string
}