## Provider
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "1.23.0"
  subscription_id = "${var.subscription_id}"
}

## Infrastructure
# Create AzureRefArch-Shared Resource Group
resource "azurerm_resource_group" "sharedrg" {
  name     = "${var.shared_resource_group_name}"
  location = "${var.shared_resource_group_location}"
}

data "azurerm_resource_group" "mgmtrg" {
  name = "${var.mgmt_resource_group_name}"
}

## get data from mgmt subnet
data "azurerm_subnet" "mgmtsubnet" {
  name                 = "${var.mgmt_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.mgmt_resource_group_name}"
}

# get data from public subnet
data "azurerm_subnet" "sharedpublicsubnet" {
  name                 = "${var.shared_public_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.mgmt_resource_group_name}"
}

# get data from private subnet
data "azurerm_subnet" "sharedprivatesubnet" {
  name                 = "${var.shared_private_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.mgmt_resource_group_name}"
}

# get data from web subnet
data "azurerm_subnet" "sharedwebsubnet" {
  name                 = "${var.shared_web_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.mgmt_resource_group_name}"
}

# get data from business subnet
data "azurerm_subnet" "sharedbusinesssubnet" {
  name                 = "${var.shared_business_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.mgmt_resource_group_name}"
}

# get data from db subnet
data "azurerm_subnet" "shareddbsubnet" {
  name                 = "${var.shared_db_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.mgmt_resource_group_name}"
}

# get data from vpn subnet
data "azurerm_subnet" "sharedvpnsubnet" {
  name                 = "${var.shared_vpn_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.mgmt_resource_group_name}"
}

# Create the Firewall diagnostic storage account
resource "azurerm_storage_account" "sharedstorage" {
  name                     = "${var.shared_storage_acct_name}"
  resource_group_name      = "${azurerm_resource_group.sharedrg.name}"
  location                 = "${var.shared_resource_group_location}"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the Firewall availability set
resource "azurerm_availability_set" "sharedas" {
  name                = "${var.shared_avail_set_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the public ip for Firewall 1
resource "azurerm_public_ip" "firewall1_mgmt_publicip" {
  name                = "${var.firewall1_mgmt_public_ip_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.firewall1_mgmt_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the public ip for Firewall 2
resource "azurerm_public_ip" "firewall2_mgmt_publicip" {
  name                = "${var.firewall2_mgmt_public_ip_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.firewall2_mgmt_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create Firewalls os disks
resource "azurerm_storage_account" "firewall1osdisk" {
  name                     = "${join("", list(var.firewall1_os_disk_account_name, substr(md5(azurerm_resource_group.sharedrg.id), 0, 4)))}"
  resource_group_name      = "${azurerm_resource_group.sharedrg.name}"
  location                 = "${var.shared_resource_group_location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_account" "firewall2osdisk" {
  name                     = "${join("", list(var.firewall2_os_disk_account_name, substr(md5(azurerm_resource_group.sharedrg.id), 0, 4)))}"
  resource_group_name      = "${azurerm_resource_group.sharedrg.name}"
  location                 = "${var.shared_resource_group_location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

## Create network interfaces
resource "azurerm_network_interface" "firewall1nic0" {
  name                = "${var.firewall1_vnic0_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  ip_configuration {
    name                          = "firewall1-nic0-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.mgmtsubnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.firewall1_vnic0_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.firewall1_mgmt_publicip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interfaces
resource "azurerm_network_interface" "firewall1nic1" {
  name                = "${var.firewall1_vnic1_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  ip_configuration {
    name                                    = "firewall1-nic1-ipconfig"
    subnet_id                               = "${data.azurerm_subnet.sharedpublicsubnet.id}"
    private_ip_address_allocation           = "Static"
    private_ip_address                      = "${var.firewall1_vnic1_private_ip}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"]
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interfaces
resource "azurerm_network_interface" "firewall1nic2" {
  name                = "${var.firewall1_vnic2_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  ip_configuration {
    name                          = "firewall1-nic2-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.sharedprivatesubnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.firewall1_vnic2_private_ip}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interfaces
resource "azurerm_network_interface" "firewall1nic3" {
  name                = "${var.firewall1_vnic3_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  ip_configuration {
    name                          = "firewall1-nic3-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.sharedvpnsubnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.firewall1_vnic3_private_ip}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interfaces
resource "azurerm_network_interface" "firewall2nic0" {
  name                = "${var.firewall2_vnic0_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  ip_configuration {
    name                          = "firewall2-nic0-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.mgmtsubnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.firewall2_vnic0_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.firewall2_mgmt_publicip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interfaces
resource "azurerm_network_interface" "firewall2nic1" {
  name                = "${var.firewall2_vnic1_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  ip_configuration {
    name                                    = "firewall2-nic1-ipconfig"
    subnet_id                               = "${data.azurerm_subnet.sharedpublicsubnet.id}"
    private_ip_address_allocation           = "Static"
    private_ip_address                      = "${var.firewall2_vnic1_private_ip}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"]
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interfaces
resource "azurerm_network_interface" "firewall2nic2" {
  name                = "${var.firewall2_vnic2_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  ip_configuration {
    name                          = "firewall2-nic2-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.sharedprivatesubnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.firewall2_vnic2_private_ip}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interfaces
resource "azurerm_network_interface" "firewall2nic3" {
  name                = "${var.firewall2_vnic3_name}"
  resource_group_name = "${azurerm_resource_group.sharedrg.name}"
  location            = "${var.shared_resource_group_location}"

  ip_configuration {
    name                          = "firewall2-nic3-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.sharedvpnsubnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.firewall2_vnic3_private_ip}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create Firewall VMs
# Firewall 1
resource "azurerm_virtual_machine" "firewall1" {
  name                          = "${var.firewall1_vm_name}"
  location                      = "${var.shared_resource_group_location}"
  resource_group_name           = "${azurerm_resource_group.sharedrg.name}"
  vm_size                       = "${var.firewall_vm_size}"
  availability_set_id           = "${azurerm_availability_set.sharedas.id}"
  delete_os_disk_on_termination = "true"

  depends_on = ["azurerm_network_interface.firewall1nic0",
    "azurerm_network_interface.firewall1nic1",
    "azurerm_network_interface.firewall1nic2",
    "azurerm_network_interface.firewall1nic3",
  ]

  plan {
    name      = "${var.firewallSku}"
    publisher = "${var.firewallPublisher}"
    product   = "${var.firewallOffer}"
  }

  storage_image_reference {
    publisher = "${var.firewallPublisher}"
    offer     = "${var.firewallOffer}"
    sku       = "${var.firewallSku}"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${join("", list(var.firewall1_vm_name, "-osDisk"))}"
    vhd_uri       = "${azurerm_storage_account.firewall1osdisk.primary_blob_endpoint}vhds/${var.firewall1_vm_name}-${var.firewallOffer}-${var.firewallSku}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.firewall1_vm_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  primary_network_interface_id = "${azurerm_network_interface.firewall1nic0.id}"

  network_interface_ids = ["${azurerm_network_interface.firewall1nic0.id}",
    "${azurerm_network_interface.firewall1nic1.id}",
    "${azurerm_network_interface.firewall1nic2.id}",
    "${azurerm_network_interface.firewall1nic3.id}",
  ]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Firewall 2
resource "azurerm_virtual_machine" "firewall2" {
  name                          = "${var.firewall2_vm_name}"
  location                      = "${var.shared_resource_group_location}"
  resource_group_name           = "${azurerm_resource_group.sharedrg.name}"
  vm_size                       = "${var.firewall_vm_size}"
  availability_set_id           = "${azurerm_availability_set.sharedas.id}"
  delete_os_disk_on_termination = "true"

  depends_on = ["azurerm_network_interface.firewall2nic0",
    "azurerm_network_interface.firewall2nic1",
    "azurerm_network_interface.firewall2nic2",
    "azurerm_network_interface.firewall2nic3",
  ]

  plan {
    name      = "${var.firewallSku}"
    publisher = "${var.firewallPublisher}"
    product   = "${var.firewallOffer}"
  }

  storage_image_reference {
    publisher = "${var.firewallPublisher}"
    offer     = "${var.firewallOffer}"
    sku       = "${var.firewallSku}"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${join("", list(var.firewall2_vm_name, "-osDisk"))}"
    vhd_uri       = "${azurerm_storage_account.firewall2osdisk.primary_blob_endpoint}vhds/${var.firewall2_vm_name}-${var.firewallOffer}-${var.firewallSku}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.firewall2_vm_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  primary_network_interface_id = "${azurerm_network_interface.firewall2nic0.id}"

  network_interface_ids = ["${azurerm_network_interface.firewall2nic0.id}",
    "${azurerm_network_interface.firewall2nic1.id}",
    "${azurerm_network_interface.firewall2nic2.id}",
    "${azurerm_network_interface.firewall2nic3.id}",
  ]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

## public lb pool associations
resource "azurerm_network_interface_backend_address_pool_association" "public_lb_fw1_address_pool_association" {
  network_interface_id    = "${azurerm_network_interface.firewall1nic1.id}"
  ip_configuration_name   = "firewall1-nic1-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "public_lb_fw2_address_pool_association" {
  network_interface_id    = "${azurerm_network_interface.firewall2nic1.id}"
  ip_configuration_name   = "firewall2-nic1-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"
}

## private lb pool associations
resource "azurerm_network_interface_backend_address_pool_association" "internal_lb_fw1_address_pool_association" {
  network_interface_id    = "${azurerm_network_interface.firewall1nic2.id}"
  ip_configuration_name   = "firewall1-nic2-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.internal_lb_backend_address_pool.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "internal_lb_fw2_address_pool_association" {
  network_interface_id    = "${azurerm_network_interface.firewall2nic2.id}"
  ip_configuration_name   = "firewall2-nic2-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.internal_lb_backend_address_pool.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "internal_public_lb_fw1_address_pool_association" {
  network_interface_id    = "${azurerm_network_interface.firewall1nic1.id}"
  ip_configuration_name   = "firewall1-nic1-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "internal_public_lb_fw2_address_pool_association" {
  network_interface_id    = "${azurerm_network_interface.firewall2nic1.id}"
  ip_configuration_name   = "firewall2-nic1-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "vpn_lb_fw1_address_pool_association" {
  network_interface_id    = "${azurerm_network_interface.firewall1nic3.id}"
  ip_configuration_name   = "firewall1-nic3-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.vpn_lb_backend_address_pool.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "vpn_lb_fw2_address_pool_association" {
  network_interface_id    = "${azurerm_network_interface.firewall2nic3.id}"
  ip_configuration_name   = "firewall2-nic3-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.vpn_lb_backend_address_pool.id}"
}
