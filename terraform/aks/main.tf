resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_cluster_name
  depends_on = [
    azurerm_resource_group.rg
  ]

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}