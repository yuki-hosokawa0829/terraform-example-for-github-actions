variable "resource_group_name" {
  type    = string
}

variable "location" {
  type    = string
}

variable "aks_cluster_name" {
  type    = string
}

locals {
  username = "ndsouadmin"
}