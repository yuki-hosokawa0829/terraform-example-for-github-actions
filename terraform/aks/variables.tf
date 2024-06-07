variable "resource_group_name" {
  type    = string
  default = "ndsou-test-tfaks01"
}

variable "resource_location" {
  type    = string
  default = "japanwest"
}

variable "aks_cluster_name" {
  type    = string
  default = "ndsou-test-tfaks01-cl"
}

variable "backend_resource_group_name" {
  type = string
}

variable "backend_storage_account_name" {
  type = string
}

variable "backend_container_name" {
  type = string
}

variable "backend_key" {
  type = string
}

locals {
  username = "ndsouadmin"
}