########## VARIABLES BELOW ##########
variable "ssh_install_key" {}
########## VARIABLES ABOVE ##########

########## RANCHER MASTER BELOW ##########
  ########## RANCHER MASTER GROUP BELOW ##########
    resource "azurerm_resource_group" "rancher-master-group" {
      name = "rancher-master-group"
      location = "${var.location}"
    }

    resource "azurerm_virtual_network" "rancher-master-network" {
      name = "rancher-master-network"
      address_space = ["10.0.0.0/16"]
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.rancher-master-group.name}"
    }

    resource "azurerm_subnet" "rancher-master-subnet" {
      name = "rancher-master-subnet"
      resource_group_name = "${azurerm_resource_group.rancher-master-group.name}"
      virtual_network_name = "${azurerm_virtual_network.rancher-master-network.name}"
      address_prefix = "10.0.2.0/24"
    }

    resource "azurerm_storage_account" "rancher-master-storage-account" {
      name = "exampleranchermaster"
      resource_group_name = "${azurerm_resource_group.rancher-master-group.name}"
      location = "${var.location}"
      account_type = "Standard_LRS"
    }

    resource "azurerm_storage_container" "rancher-master-storage-container" {
      name = "vhds"
      resource_group_name = "${azurerm_resource_group.rancher-master-group.name}"
      storage_account_name = "${azurerm_storage_account.rancher-master-storage-account.name}"
      container_access_type = "private"
    }

    resource "azurerm_network_security_group" "rancher-master-main-security-group" {
      name = "rancher-master-main-security-group"
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.rancher-master-group.name}"

      # open all ports here and manage firewall through ufw like sane person
      security_rule {
        name = "allow-all"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
      }
    }
  ########## RANCHER MASTER GROUP ABOVE ##########
  ########## RANCHER MASTER BELOW ##########
    resource "azurerm_public_ip" "rancher-master-public-ip" {
      name = "rancher-master-public-ip"
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.rancher-master-group.name}"
      public_ip_address_allocation = "static"
      domain_name_label = "rancher-master"
    }

    resource "azurerm_network_interface" "rancher-master-interface" {
      name = "rancher-master"
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.rancher-master-group.name}"
      network_security_group_id = "${azurerm_network_security_group.rancher-master-main-security-group.id}"

      ip_configuration {
        name = "rancher-master"
        subnet_id = "${azurerm_subnet.rancher-master-subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.rancher-master-public-ip.id}"
      }
    }

    resource "azurerm_virtual_machine" "rancher-master" {
      name = "rancher-master"
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.rancher-master-group.name}"
      network_interface_ids = ["${azurerm_network_interface.rancher-master-interface.id}"]
      vm_size = "Standard_A1"

      storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04.0-DAILY-LTS"
        version = "latest"
      }

      storage_os_disk {
        name = "rancher-master"
        vhd_uri = "${azurerm_storage_account.rancher-master-storage-account.primary_blob_endpoint}${azurerm_storage_container.rancher-master-storage-container.name}/rancher-master.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
      }

      os_profile {
        computer_name = "rancher-master"
        admin_username = "deploy"
        admin_password = ""
      }

      os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
          path = "/home/deploy/.ssh/authorized_keys"
          key_data = "${file(var.ssh_install_key)}"
        }
      }

      tags {
        role = "rancher-master"
        parent = "production"
        ip = "${azurerm_public_ip.rancher-master-public-ip.ip_address}"
      }
    }
  ########## RANCHER MASTER ABOVE ##########
########## RANCHER MASTER ABOVE ##########
