# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#dc01
resource "azurerm_public_ip" "static01" {
  name                = "${var.prefix}-dc-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "dc_nic" {
  name                = join("-", [var.prefix, "dc-primary"])
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.4"
    public_ip_address_id          = azurerm_public_ip.static01.id
  }
}

resource "azurerm_windows_virtual_machine" "domain_controller" {
  name                = local.virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2ms"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  custom_data         = local.custom_data

  network_interface_ids = [
    azurerm_network_interface.dc_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  additional_unattend_content {
    content = local.auto_logon_data
    setting = "AutoLogon"
  }

  additional_unattend_content {
    content = local.first_logon_data
    setting = "FirstLogonCommands"
  }
}

resource "azurerm_virtual_machine_extension" "create-ad-forest" {
  name                 = "create-active-directory-forest"
  virtual_machine_id   = azurerm_windows_virtual_machine.domain_controller.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings             = <<SETTINGS
  {
    "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
  }
SETTINGS
}


#dc02
resource "azurerm_public_ip" "static02" {
  name                = "${var.prefix}-dc02-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "primary" {
  name                = "${var.prefix}-dc02-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
    public_ip_address_id          = azurerm_public_ip.static02.id
  }
}

resource "azurerm_windows_virtual_machine" "domain_contoller02" {
  name                     = "${var.prefix}-dc02"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  size                     = "Standard_B2ms"
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  provision_vm_agent       = true
  enable_automatic_updates = true

  network_interface_ids = [
    azurerm_network_interface.primary.id,
  ]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}


resource "azurerm_virtual_machine_extension" "join_domain" {
  name                 = azurerm_windows_virtual_machine.domain_contoller02.name
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  virtual_machine_id   = azurerm_windows_virtual_machine.domain_contoller02.id

  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain_name}",
        "OUPath": "",
        "User": "${var.admin_username}@${var.active_directory_domain_name}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.admin_password}"
    }
SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.create-ad-forest
  ]

}


resource "azurerm_virtual_machine_extension" "promote_as_domain_controller" {
  name                 = "promote-as-domain-controller"
  virtual_machine_id   = azurerm_windows_virtual_machine.domain_contoller02.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings             = <<SETTINGS
  {
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.promote_as_domain_script.rendered)}')) | Out-File -filepath PromoteAsDomain.ps1\" && powershell -ExecutionPolicy Unrestricted -File PromoteAsDomain.ps1 -domain_name ${data.template_file.promote_as_domain_script.vars.domain_name} -domain_user_upn ${data.template_file.promote_as_domain_script.vars.domain_user_upn} -domain_user_password ${data.template_file.promote_as_domain_script.vars.domain_user_password}"
  }
SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.join_domain
  ]
}

#Script to promote as a domain controller
data "template_file" "promote_as_domain_script" {
  template = file("${path.module}/files/PromoteAsDomain.ps1")
  vars = {
    domain_name          = "${var.active_directory_domain_name}"
    domain_user_upn      = "${var.admin_username}"
    domain_user_password = "${var.admin_password}"
  }
}