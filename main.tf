provider "azurerm" {
  version = ">2.0.0"
  features {}
}

resource "azurerm_resource_group" "polygraph" {
  name     = "PolyGraph_rg"
  location = "East US 2"
}

resource "azurerm_kubernetes_cluster" "polygraph" {
  name                = "polygraph"
  location            = azurerm_resource_group.polygraph.location
  resource_group_name = azurerm_resource_group.polygraph.name
  dns_prefix          = "polygraph"

  default_node_pool {
    name       = "default"
    node_count = 2 
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

#output "client_certificate" {
#  value = azurerm_kubernetes_cluster.polygraph.kube_config.0.client_certificate
#}
#
#output "kube_config" {
#  value = azurerm_kubernetes_cluster.polygraph.kube_config_raw
#}
