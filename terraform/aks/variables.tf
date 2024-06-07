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

locals {
  username = "ndsouadmin"
}