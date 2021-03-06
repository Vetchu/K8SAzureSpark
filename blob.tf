resource "azurerm_storage_account" "polygraph_storage_account" {
  name                     = "polygraphstorageaccount"
  resource_group_name      = azurerm_resource_group.polygraph.name
  location                 = azurerm_resource_group.polygraph.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "polygraph_storage_container" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.polygraph_storage_account.name
  container_access_type = "private"
}