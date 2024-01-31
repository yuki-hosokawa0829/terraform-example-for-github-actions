# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "addc"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "JapanWest"
}

variable "admin_username" {
  description = "Username for the Administrator account"
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Password for the Administrator account"
  default     = "P@ssw0rd0123"
}
