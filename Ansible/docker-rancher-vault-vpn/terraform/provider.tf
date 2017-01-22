########## VARIABLES BELOW ##########
variable "azure_client_secret" {}
variable "location" { default = "West Europe" }
########## VARIABLES ABOVE ##########

########## PROVIDERS BELOW ##########
  ########## AZURE BELOW ##########
    provider "azurerm" {
      subscription_id = ""
      client_id       = ""
      client_secret   = "${var.azure_client_secret}"
      tenant_id       = ""
    }
  ########## AZURE ABOVE ##########
########## PROVIDERS ABOVE ##########
