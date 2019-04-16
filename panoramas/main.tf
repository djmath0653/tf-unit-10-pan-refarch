## Provider
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "1.23.0"
  subscription_id = "${var.subscription_id}"
}

## Panorama Infrastructure
# Create AzureRefArch Resource Group
resource "azurerm_resource_group" "mgmtrg" {
  name     = "${var.mgmt_resource_group_name}"
  location = "${var.mgmt_resource_group_location}"
}

# Create a vnet within the resource group
resource "azurerm_virtual_network" "azrefarchvnet" {
  name                = "${var.azure_refarch_vnet_name}"
  address_space       = ["${var.refarch_mgmt_address_space}", "${var.refarch_shrd_ext_address_space}", "${var.refarch_shrd_address_space}"]
  location            = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"

  tags {
    environment = "${var.environment_tag_name}"
  }
}

# Create subnet within the vnet
resource "azurerm_subnet" "mgmtsubnet" {
  name                 = "${var.mgmt_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.mgmtrg.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.mgmt_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedpublicsubnet" {
  name                 = "${var.shared_public_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.mgmtrg.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_public_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedprivatesubnet" {
  name                 = "${var.shared_private_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.mgmtrg.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_private_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedwebsubnet" {
  name                 = "${var.shared_web_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.mgmtrg.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_web_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedbusinesssubnet" {
  name                 = "${var.shared_business_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.mgmtrg.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_business_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "shareddbsubnet" {
  name                 = "${var.shared_db_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.mgmtrg.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_db_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedvpnsubnet" {
  name                 = "${var.shared_vpn_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.mgmtrg.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_vpn_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedgwsubnet" {
  name                 = "${var.shared_gw_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.mgmtrg.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_gw_subnet_prefix}"
}

# Create the public ip for Panorama 1
resource "azurerm_public_ip" "panorama1_mgmt_publicip" {
  name                = "${var.panorama1_mgmt_public_ip_name}"
  location            = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.panorama1_mgmt_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create network securirty group
resource "azurerm_network_security_group" "mgmtnsg" {
  name                = "${var.mgmt_nsg_name}"
  location            = "${var.mgmt_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"

  security_rule {
    name                       = "AllowHTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.environment_tag_name}"
  }
}

# Create network securirty group
resource "azurerm_network_security_group" "sharedpublicnsg" {
  name                = "${var.shared_fw_pub_nsg_name}"
  location            = "${var.mgmt_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"

  security_rule {
    name                       = "AllowHTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP-Inbound"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.environment_tag_name}"
  }
}

# Create network securirty group
resource "azurerm_network_security_group" "sharedallowallnsg" {
  name                = "${var.shared_allow_all_nsg_name}"
  location            = "${var.mgmt_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"

  security_rule {
    name                       = "AllowAll-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.environment_tag_name}"
  }
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "mgmtsubnetnsgassoc" {
  subnet_id                 = "${azurerm_subnet.mgmtsubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.mgmtnsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "sharedpublicsubnetnsgassoc" {
  subnet_id                 = "${azurerm_subnet.sharedpublicsubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sharedpublicnsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "sharedprivatesubnetnsgassoc" {
  subnet_id                 = "${azurerm_subnet.sharedprivatesubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sharedallowallnsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "sharedwebsubnetnsgassoc" {
  subnet_id                 = "${azurerm_subnet.sharedwebsubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sharedallowallnsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "sharedbusinesssubnetnsgassoc" {
  subnet_id                 = "${azurerm_subnet.sharedbusinesssubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sharedallowallnsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "shareddbsubnetnsgassoc" {
  subnet_id                 = "${azurerm_subnet.shareddbsubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sharedallowallnsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "sharedvpnsubnetnsgassoc" {
  subnet_id                 = "${azurerm_subnet.sharedvpnsubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sharedallowallnsg.id}"
}

## Create route tables
resource "azurerm_route_table" "AzureRefArch-Management" {
  name                          = "AzureRefArch-Management"
  location                      = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name           = "${azurerm_resource_group.mgmtrg.name}"
  disable_bgp_route_propagation = false

  route {
    name           = "Blackhole-Private"
    address_prefix = "10.5.0.0/20"
    next_hop_type  = "None"
  }

  route {
    name           = "Blackhole-Public"
    address_prefix = "172.16.0.0/23"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.6.0.0"
    address_prefix         = "10.6.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_subnet_route_table_association" "AzureRefArch-Management-Assoc" {
  subnet_id      = "${azurerm_subnet.mgmtsubnet.id}"
  route_table_id = "${azurerm_route_table.AzureRefArch-Management.id}"
}

resource "azurerm_route_table" "AzureRefArch-Shared-Business" {
  name                          = "AzureRefArch-Shared-Business"
  location                      = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name           = "${azurerm_resource_group.mgmtrg.name}"
  disable_bgp_route_propagation = false

  route {
    name           = "Backdoor"
    address_prefix = "73.229.177.164/32"
    next_hop_type  = "Internet"
  }

  route {
    name           = "Blackhole-Management"
    address_prefix = "192.168.255.0/24"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.6.0.0"
    address_prefix         = "10.6.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-172.16.0.0"
    address_prefix         = "172.16.0.0/23"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "UDR-default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_subnet_route_table_association" "AzureRefArch-Shared-Business-Assoc" {
  subnet_id      = "${azurerm_subnet.sharedbusinesssubnet.id}"
  route_table_id = "${azurerm_route_table.AzureRefArch-Shared-Business.id}"
}

resource "azurerm_route_table" "AzureRefArch-Shared-DB" {
  name                          = "AzureRefArch-Shared-DB"
  location                      = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name           = "${azurerm_resource_group.mgmtrg.name}"
  disable_bgp_route_propagation = false

  route {
    name           = "Backdoor"
    address_prefix = "73.229.177.164/32"
    next_hop_type  = "Internet"
  }

  route {
    name           = "Blackhole-Management"
    address_prefix = "192.168.255.0/24"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.6.0.0"
    address_prefix         = "10.6.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-172.16.0.0"
    address_prefix         = "172.16.0.0/23"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "UDR-default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_subnet_route_table_association" "AzureRefArch-Shared-DB-Assoc" {
  subnet_id      = "${azurerm_subnet.shareddbsubnet.id}"
  route_table_id = "${azurerm_route_table.AzureRefArch-Shared-DB.id}"
}

resource "azurerm_route_table" "AzureRefArch-Shared-Web" {
  name                          = "AzureRefArch-Shared-Web"
  location                      = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name           = "${azurerm_resource_group.mgmtrg.name}"
  disable_bgp_route_propagation = false

  route {
    name           = "Backdoor"
    address_prefix = "73.229.177.164/32"
    next_hop_type  = "Internet"
  }

  route {
    name           = "Blackhole-Management"
    address_prefix = "192.168.255.0/24"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.6.0.0"
    address_prefix         = "10.6.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-172.16.0.0"
    address_prefix         = "172.16.0.0/23"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "UDR-default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_subnet_route_table_association" "AzureRefArch-Shared-Web-Assoc" {
  subnet_id      = "${azurerm_subnet.sharedwebsubnet.id}"
  route_table_id = "${azurerm_route_table.AzureRefArch-Shared-Web.id}"
}

resource "azurerm_route_table" "AzureRefArch-Shared-Private" {
  name                          = "AzureRefArch-Shared-Private"
  location                      = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name           = "${azurerm_resource_group.mgmtrg.name}"
  disable_bgp_route_propagation = false

  route {
    name           = "Backdoor"
    address_prefix = "73.229.177.164/32"
    next_hop_type  = "Internet"
  }

  route {
    name           = "Blackhole-Management"
    address_prefix = "192.168.255.0/24"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.6.0.0"
    address_prefix         = "10.6.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-172.16.0.0"
    address_prefix         = "172.16.0.0/23"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "UDR-default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_subnet_route_table_association" "AzureRefArch-Shared-Private-Assoc" {
  subnet_id      = "${azurerm_subnet.sharedprivatesubnet.id}"
  route_table_id = "${azurerm_route_table.AzureRefArch-Shared-Private.id}"
}

resource "azurerm_route_table" "AzureRefArch-Shared-Public" {
  name                          = "AzureRefArch-Shared-Public"
  location                      = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name           = "${azurerm_resource_group.mgmtrg.name}"
  disable_bgp_route_propagation = false

  route {
    name           = "Blackhole-OnSite"
    address_prefix = "10.6.0.0/16"
    next_hop_type  = "None"
  }

  route {
    name           = "Blackhole-Management"
    address_prefix = "192.168.255.0/24"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.5.0.0"
    address_prefix         = "10.5.0.0/20"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.1.21"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_subnet_route_table_association" "AzureRefArch-Shared-Public-Assoc" {
  subnet_id      = "${azurerm_subnet.sharedpublicsubnet.id}"
  route_table_id = "${azurerm_route_table.AzureRefArch-Shared-Public.id}"
}

# Create the public ip for Panorama 2
resource "azurerm_public_ip" "panorama2_mgmt_publicip" {
  name                = "${var.panorama2_mgmt_public_ip_name}"
  location            = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.panorama2_mgmt_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the Panorama availability set
resource "azurerm_availability_set" "panoramaas" {
  name                = "${var.panorama_avail_set_name}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"
  location            = "${azurerm_resource_group.mgmtrg.location}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the Panorama diagnostic storage account
resource "azurerm_storage_account" "panoramadiagstor" {
  name                     = "${var.panorama_storage_acct_name}"
  resource_group_name      = "${azurerm_resource_group.mgmtrg.name}"
  location                 = "${azurerm_resource_group.mgmtrg.location}"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create Panoram os disks
resource "azurerm_storage_account" "panorama1osdisk" {
  name                     = "${join("", list(var.panorama1_os_disk_account_name, substr(md5(azurerm_resource_group.mgmtrg.id), 0, 4)))}"
  resource_group_name      = "${azurerm_resource_group.mgmtrg.name}"
  location                 = "${azurerm_resource_group.mgmtrg.location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_account" "panorama2osdisk" {
  name                     = "${join("", list(var.panorama2_os_disk_account_name, substr(md5(azurerm_resource_group.mgmtrg.id), 0, 4)))}"
  resource_group_name      = "${azurerm_resource_group.mgmtrg.name}"
  location                 = "${azurerm_resource_group.mgmtrg.location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

## Create network interfaces
resource "azurerm_network_interface" "panoram1nic0" {
  name                = "${var.panorama1_vnic0_name}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"
  location            = "${azurerm_resource_group.mgmtrg.location}"

  ip_configuration {
    name                          = "panoram1-nic0-ipconfig"
    subnet_id                     = "${azurerm_subnet.mgmtsubnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.panorama1_vnic0_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.panorama1_mgmt_publicip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_network_interface" "panoram2nic0" {
  name                = "${var.panorama2_vnic0_name}"
  resource_group_name = "${azurerm_resource_group.mgmtrg.name}"
  location            = "${azurerm_resource_group.mgmtrg.location}"

  ip_configuration {
    name                          = "panoram2-nic0-ipconfig"
    subnet_id                     = "${azurerm_subnet.mgmtsubnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.panorama2_vnic0_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.panorama2_mgmt_publicip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create Panroama VMs
# Panorama 1
resource "azurerm_virtual_machine" "panorama1" {
  name                          = "${var.panorama1_vm_name}"
  location                      = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name           = "${azurerm_resource_group.mgmtrg.name}"
  vm_size                       = "${var.panorama_vm_size}"
  availability_set_id           = "${azurerm_availability_set.panoramaas.id}"
  delete_os_disk_on_termination = "true"
  depends_on                    = ["azurerm_network_interface.panoram1nic0"]

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

  primary_network_interface_id = "${azurerm_network_interface.panoram1nic0.id}"
  network_interface_ids        = ["${azurerm_network_interface.panoram1nic0.id}"]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Panorama 2
resource "azurerm_virtual_machine" "panorama2" {
  name                          = "${var.panorama2_vm_name}"
  location                      = "${azurerm_resource_group.mgmtrg.location}"
  resource_group_name           = "${azurerm_resource_group.mgmtrg.name}"
  vm_size                       = "${var.panorama_vm_size}"
  availability_set_id           = "${azurerm_availability_set.panoramaas.id}"
  delete_os_disk_on_termination = "true"
  depends_on                    = ["azurerm_network_interface.panoram2nic0"]

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

  primary_network_interface_id = "${azurerm_network_interface.panoram2nic0.id}"
  network_interface_ids        = ["${azurerm_network_interface.panoram2nic0.id}"]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
