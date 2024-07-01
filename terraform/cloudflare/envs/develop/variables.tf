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

#variable "backend_endpoint" {
#  description = "The endpoint for the backend"
#  type        = string
#}

#variable "backend_bucket" {
#  description = "The bucket for the backend"
#  type        = string
#}

#variable "backend_key" {
#  description = "The key for the backend"
#  type        = string
#}

#variable "backend_region" {
#  description = "The region for the backend"
#  type        = string
#}