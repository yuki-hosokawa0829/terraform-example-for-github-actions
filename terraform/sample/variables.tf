variable "location" {
  default = "japanwest"
}

variable "admin_username" {
  default = "adminuser"
}

variable "admin_password" {
  default = "P@ssw0rd1234"
  sensitive = false
}

locals {
  count = 3
}