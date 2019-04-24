## Provider
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "1.23.0"
  subscription_id = "${var.subscription_id}"
}

## Panorama Infrastructure
# Create Panorama Resource Group
resource "azurerm_resource_group" "panorama_resource_group" {
  name     = "${var.panorama_resource_group_name}"
  location = "${var.panorama_resource_group_location}"
}

# # get subnet data
# data "azurerm_subnet" "management_subnet" {
#   name                 = "${var.management_subnet_name}"
#   resource_group_name  = "${var.shared_resource_group_name}"
#   virtual_network_name = "${var.refarch_vnet_name}"
# }

## get data from mgmt subnet
data "azurerm_subnet" "management_subnet" {
  name                 = "${var.management_subnet_name}"
  virtual_network_name = "${var.refarch_vnet_name}"
  resource_group_name  = "${var.shared_resource_group_name}"
}

# Create the public ip for Panorama 1
resource "azurerm_public_ip" "panorama1_public_ip" {
  name                = "${var.panorama1_public_ip_name}"
  location            = "${var.panorama_resource_group_location}"
  resource_group_name = "${var.panorama_resource_group_name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.panorama1_domain_name_label}"
  depends_on          = ["panorama_resource_group"]

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the public ip for Panorama 2
resource "azurerm_public_ip" "panorama2_public_ip" {
  name                = "${var.panorama2_public_ip_name}"
  location            = "${var.panorama_resource_group_location}"
  resource_group_name = "${var.panorama_resource_group_name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.panorama2_domain_name_label}"
  depends_on          = ["panorama_resource_group"]

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the Panorama availability set
resource "azurerm_availability_set" "panorama_as" {
  name                = "${var.panorama_avail_set_name}"
  resource_group_name = "${azurerm_resource_group.panorama_resource_group.name}"
  location            = "${azurerm_resource_group.panorama_resource_group.location}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the Panorama diagnostic storage account
resource "azurerm_storage_account" "panorama_storage_acct" {
  name                     = "${var.panorama_storage_acct_name}"
  resource_group_name      = "${azurerm_resource_group.panorama_resource_group.name}"
  location                 = "${azurerm_resource_group.panorama_resource_group.location}"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create Panoram os disks
resource "azurerm_storage_account" "panorama1osdisk" {
  name                     = "${join("", list(var.panorama1_os_disk_account_name, substr(md5(azurerm_resource_group.panorama_resource_group.id), 0, 4)))}"
  resource_group_name      = "${azurerm_resource_group.panorama_resource_group.name}"
  location                 = "${azurerm_resource_group.panorama_resource_group.location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_account" "panorama2osdisk" {
  name                     = "${join("", list(var.panorama2_os_disk_account_name, substr(md5(azurerm_resource_group.panorama_resource_group.id), 0, 4)))}"
  resource_group_name      = "${azurerm_resource_group.panorama_resource_group.name}"
  location                 = "${azurerm_resource_group.panorama_resource_group.location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

## Create network interfaces
resource "azurerm_network_interface" "panorama1_vnic0" {
  name                = "${var.panorama1_vnic0_name}"
  resource_group_name = "${azurerm_resource_group.panorama_resource_group.name}"
  location            = "${azurerm_resource_group.panorama_resource_group.location}"

  ip_configuration {
    name                          = "panoram1-nic0-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.management_subnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.panorama1_vnic0_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.panorama1_public_ip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_network_interface" "panorama2_vnic0" {
  name                = "${var.panorama2_vnic0_name}"
  resource_group_name = "${azurerm_resource_group.panorama_resource_group.name}"
  location            = "${azurerm_resource_group.panorama_resource_group.location}"

  ip_configuration {
    name                          = "panoram2-nic0-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.management_subnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.panorama2_vnic0_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.panorama2_public_ip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create Panroama VMs
# Panorama 1
resource "azurerm_virtual_machine" "panorama1_vm" {
  name                          = "${var.panorama1_vm_name}"
  location                      = "${azurerm_resource_group.panorama_resource_group.location}"
  resource_group_name           = "${azurerm_resource_group.panorama_resource_group.name}"
  vm_size                       = "${var.panorama_vm_size}"
  availability_set_id           = "${azurerm_availability_set.panorama_as.id}"
  delete_os_disk_on_termination = "true"
  depends_on                    = ["azurerm_network_interface.panorama1_vnic0"]

  plan {
    name      = "${var.panoramaSku}"
    publisher = "${var.panoramaPublisher}"
    product   = "${var.panoramaOffer}"
  }

  storage_image_reference {
    publisher = "${var.panoramaPublisher}"
    offer     = "${var.panoramaOffer}"
    sku       = "${var.panoramaSku}"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${join("", list(var.panorama1_vm_name, "-osDisk"))}"
    vhd_uri       = "${azurerm_storage_account.panorama1osdisk.primary_blob_endpoint}vhds/${var.panorama1_vm_name}-${var.panoramaOffer}-${var.panoramaSku}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.panorama1_vm_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  primary_network_interface_id = "${azurerm_network_interface.panorama1_vnic0.id}"
  network_interface_ids        = ["${azurerm_network_interface.panorama1_vnic0.id}"]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Panorama 2
resource "azurerm_virtual_machine" "panorama2_vm" {
  name                          = "${var.panorama2_vm_name}"
  location                      = "${azurerm_resource_group.panorama_resource_group.location}"
  resource_group_name           = "${azurerm_resource_group.panorama_resource_group.name}"
  vm_size                       = "${var.panorama_vm_size}"
  availability_set_id           = "${azurerm_availability_set.panorama_as.id}"
  delete_os_disk_on_termination = "true"
  depends_on                    = ["azurerm_network_interface.panorama2_vnic0"]

  plan {
    name      = "${var.panoramaSku}"
    publisher = "${var.panoramaPublisher}"
    product   = "${var.panoramaOffer}"
  }

  storage_image_reference {
    publisher = "${var.panoramaPublisher}"
    offer     = "${var.panoramaOffer}"
    sku       = "${var.panoramaSku}"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${join("", list(var.panorama2_vm_name, "-osDisk"))}"
    vhd_uri       = "${azurerm_storage_account.panorama2osdisk.primary_blob_endpoint}vhds/${var.panorama2_vm_name}-${var.panoramaOffer}-${var.panoramaSku}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.panorama2_vm_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  primary_network_interface_id = "${azurerm_network_interface.panorama2_vnic0.id}"
  network_interface_ids        = ["${azurerm_network_interface.panorama2_vnic0.id}"]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
