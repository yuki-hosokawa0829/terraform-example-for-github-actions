variable "environment" {
  description = "The environment to deploy to."
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

variable "backend_endpoint" {
  description = "The endpoint to access the backend resources."
  type        = string
}

variable "backend_bucket" {
  description = "The name of the bucket to store the Terraform state file."
  type        = string
}

variable "backend_key" {
  description = "The key to access the backend resources."
  type        = string
}

variable "backend_region" {
  description = "The region in which the backend resources are located."
  type        = string
}