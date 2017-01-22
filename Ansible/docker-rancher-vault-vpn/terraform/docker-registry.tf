########## DOCKER REGISTRY BELOW ##########
  ########## DOCKER REGISTRY GROUP BELOW ##########
    resource "azurerm_resource_group" "docker-registry-group" {
      name = "docker-registry-group"
      location = "${var.location}"
    }

    resource "azurerm_storage_account" "docker-registry-storage-account" {
      name = "exampledockerregistry"
      resource_group_name = "${azurerm_resource_group.docker-registry-group.name}"
      location = "${var.location}"
      account_type = "Standard_LRS"
    }

    resource "azurerm_storage_container" "docker-registry-storage-container-registry" {
      name = "registry"
      resource_group_name = "${azurerm_resource_group.docker-registry-group.name}"
      storage_account_name = "${azurerm_storage_account.docker-registry-storage-account.name}"
      container_access_type = "private"
    }
  ########## DOCKER REGISTRY ABOVE ##########
########## DOCKER REGISTRY ABOVE ##########
