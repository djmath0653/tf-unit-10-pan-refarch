## Provider
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "1.23.0"
  subscription_id = "${var.subscription_id}"
}

## Test VM Infrastructure
# Create AzureRefArch Resource Group

resource "azurerm_resource_group" "testvmrg" {
  name     = "${var.testvm_resource_group_name}"
  location = "${var.testvm_resource_group_location}"
}

## get the id of web subnet
data "azurerm_subnet" "sharedwebsubnet" {
  name                 = "${var.shared_web_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.shared_resource_group_name}"
}

## get the id of db subnet
data "azurerm_subnet" "shareddbsubnet" {
  name                 = "${var.shared_db_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.shared_resource_group_name}"
}

## get the id of buisiness subnet
data "azurerm_subnet" "sharedbusinesssubnet" {
  name                 = "${var.shared_web_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.shared_resource_group_name}"
}

# Create the public ip for web test vm
resource "azurerm_public_ip" "webtestpublicip" {
  name                = "${var.web_test_publicip_name}"
  location            = "${var.testvm_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.testvmrg.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.web_test_domain_name_label}"
}

# Create the public ip for db test vm
resource "azurerm_public_ip" "dbtestpublicip" {
  name                = "${var.db_test_publicip_name}"
  location            = "${var.testvm_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.testvmrg.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.db_test_domain_name_label}"
}

# Create the public ip for business
resource "azurerm_public_ip" "businesstestpublicip" {
  name                = "${var.business_test_publicip_name}"
  location            = "${var.testvm_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.testvmrg.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.business_test_domain_name_label}"
}

## Create network interface for web test
resource "azurerm_network_interface" "webtestnic0" {
  name                = "WebTestVM"
  resource_group_name = "${var.testvm_resource_group_name}"
  location            = "${var.testvm_resource_group_location}"

  ip_configuration {
    name                          = "web-test-nic0-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.sharedwebsubnet.id}"
    private_ip_address_allocation = "Dynamic"

    # private_ip_address            = "${var.panorama1_vnic0_private_ip}"
    public_ip_address_id = "${azurerm_public_ip.webtestpublicip.id}"
  }
}

## Create network interface for db test
resource "azurerm_network_interface" "dbtestnic0" {
  name                = "db-test-nic0-ipconfig"
  resource_group_name = "${var.testvm_resource_group_name}"
  location            = "${var.testvm_resource_group_location}"

  ip_configuration {
    name                          = "db-test-nic0-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.shareddbsubnet.id}"
    private_ip_address_allocation = "Dynamic"

    # private_ip_address            = "${var.panorama2_vnic0_private_ip}"
    public_ip_address_id = "${azurerm_public_ip.dbtestpublicip.id}"
  }
}

## Create network interface for business test
resource "azurerm_network_interface" "businesstestnic0" {
  name                = "business-test-nic0-ipconfig"
  resource_group_name = "${var.testvm_resource_group_name}"
  location            = "${var.testvm_resource_group_location}"

  ip_configuration {
    name                          = "business-test-nic0-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.sharedbusinesssubnet.id}"
    private_ip_address_allocation = "Dynamic"

    # private_ip_address            = "${var.panorama2_vnic0_private_ip}"
    public_ip_address_id = "${azurerm_public_ip.businesstestpublicip.id}"
  }
}

## Create VM
# Web Test VM
resource "azurerm_virtual_machine" "webtestvm" {
  name                          = "${var.web_test_1vm_name}"
  location                      = "${var.testvm_resource_group_location}"
  resource_group_name           = "${var.testvm_resource_group_name}"
  network_interface_ids         = ["${azurerm_network_interface.webtestnic0.id}"]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "webtestvmosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "webtestvm"
    admin_username = "xmrefarchadmin"
    admin_password = "s0wqLK0N5f0!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# DB Test VM
resource "azurerm_virtual_machine" "dbtestvm" {
  name                          = "${var.db_test_1vm_name}"
  location                      = "${var.testvm_resource_group_location}"
  resource_group_name           = "${var.testvm_resource_group_name}"
  network_interface_ids         = ["${azurerm_network_interface.dbtestnic0.id}"]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "dbtestvmosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "dbtestvm"
    admin_username = "xmrefarchadmin"
    admin_password = "s0wqLK0N5f0!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Business Test VM
resource "azurerm_virtual_machine" "businesstestvm" {
  name                          = "${var.business_test_1vm_name}"
  location                      = "${var.testvm_resource_group_location}"
  resource_group_name           = "${var.testvm_resource_group_name}"
  network_interface_ids         = ["${azurerm_network_interface.businesstestnic0.id}"]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "businesstestvmosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "businesstestvm"
    admin_username = "xmrefarchadmin"
    admin_password = "s0wqLK0N5f0!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
