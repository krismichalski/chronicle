########## CDN BELOW ##########
  ########## CDN GROUP BELOW ##########
    resource "azurerm_resource_group" "cdn-group" {
      name = "cdn-group"
      location = "${var.location}"
    }

    resource "azurerm_storage_account" "cdn-storage-account" {
      name = "examplecdn"
      resource_group_name = "${azurerm_resource_group.cdn-group.name}"
      location = "${var.location}"
      account_type = "Standard_RAGRS"
    }

    resource "azurerm_cdn_profile" "cdn-cdn-profile" {
      name = "example"
      resource_group_name = "${azurerm_resource_group.cdn-group.name}"
      location = "${var.location}"
      sku = "Standard"
    }

    resource "azurerm_cdn_endpoint" "cdn-cdn-endpoint" {
      name = "examplecdn"
      resource_group_name = "${azurerm_resource_group.cdn-group.name}"
      location = "${var.location}"
      profile_name = "${azurerm_cdn_profile.cdn-cdn-profile.name}"

      origin_host_header = "${replace(replace(azurerm_storage_account.cdn-storage-account.primary_blob_endpoint, "https:", ""), "/", "")}"

      origin {
        name = "examplecdnorigin"
        ##### MUST BE! THE SAME AS origin_host_header ABOVE! #####
        host_name = "${replace(replace(azurerm_storage_account.cdn-storage-account.primary_blob_endpoint, "https:", ""), "/", "")}"
        https_port = 443
        http_port = 80
      }
    }
  ########## CDN ABOVE ##########
########## CDN ABOVE ##########
