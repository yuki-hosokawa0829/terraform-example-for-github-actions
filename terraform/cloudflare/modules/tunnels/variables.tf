variable "environment" {
  description = "The environment to deploy to."
  type        = string
}

variable "prefix" {
  description = "The prefix to use for resources."
  type        = string
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