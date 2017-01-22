########## VARIABLES BELOW ##########
variable "ssh_install_key" {}
########## VARIABLES ABOVE ##########

########## DB MASTER BELOW ##########
  ########## DB MASTER GROUP BELOW ##########
    resource "azurerm_resource_group" "db-master-group" {
      name = "db-master-group"
      location = "${var.location}"
    }

    resource "azurerm_virtual_network" "db-master-network" {
      name = "db-master-network"
      address_space = ["10.0.0.0/16"]
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.db-master-group.name}"
    }

    resource "azurerm_subnet" "db-master-subnet" {
      name = "db-master-subnet"
      resource_group_name = "${azurerm_resource_group.db-master-group.name}"
      virtual_network_name = "${azurerm_virtual_network.db-master-network.name}"
      address_prefix = "10.0.2.0/24"
    }

    resource "azurerm_storage_account" "db-master-storage-account" {
      name = "exampledbmaster"
      resource_group_name = "${azurerm_resource_group.db-master-group.name}"
      location = "${var.location}"
      account_type = "Standard_LRS"
    }

    resource "azurerm_storage_container" "db-master-storage-container" {
      name = "vhds"
      resource_group_name = "${azurerm_resource_group.db-master-group.name}"
      storage_account_name = "${azurerm_storage_account.db-master-storage-account.name}"
      container_access_type = "private"
    }

    resource "azurerm_network_security_group" "db-master-main-security-group" {
      name = "db-master-main-security-group"
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.db-master-group.name}"

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
  ########## DB MASTER GROUP ABOVE ##########
  ########## DB MASTER BELOW ##########
    resource "azurerm_public_ip" "db-master-public-ip" {
      name = "db-master-public-ip"
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.db-master-group.name}"
      public_ip_address_allocation = "static"
      domain_name_label = "db-master"
    }

    resource "azurerm_network_interface" "db-master-interface" {
      name = "db-master"
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.db-master-group.name}"
      network_security_group_id = "${azurerm_network_security_group.db-master-main-security-group.id}"

      ip_configuration {
        name = "db-master"
        subnet_id = "${azurerm_subnet.db-master-subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.db-master-public-ip.id}"
      }
    }

    resource "azurerm_virtual_machine" "db-master" {
      name = "db-master"
      location = "${var.location}"
      resource_group_name = "${azurerm_resource_group.db-master-group.name}"
      network_interface_ids = ["${azurerm_network_interface.db-master-interface.id}"]
      vm_size = "Standard_A1"

      storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04.0-DAILY-LTS"
        version = "latest"
      }

      storage_os_disk {
        name = "db-master"
        vhd_uri = "${azurerm_storage_account.db-master-storage-account.primary_blob_endpoint}${azurerm_storage_container.db-master-storage-container.name}/db-master.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
      }

      os_profile {
        computer_name = "db-master"
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
        role = "db"
        parent = "production"
        ip = "${azurerm_public_ip.db-master-public-ip.ip_address}"
      }
    }
  ########## DB MASTER ABOVE ##########
########## DB MASTER ABOVE ##########
