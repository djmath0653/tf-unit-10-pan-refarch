## Provider
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "1.23.0"
  subscription_id = "${var.subscription_id}"
}

## Test VM Infrastructure
# Create AzureRefArch Resource Group

resource "azurerm_resource_group" "test_vm_resource_group" {
  name     = "${var.testvm_resource_group_name}"
  location = "${var.testvm_resource_group_location}"
}

#Subnets
# Create subnet within the vnet
resource "azurerm_subnet" "web_subnet" {
  name                 = "${var.web_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.shared_vnet.name}"
  address_prefix       = "${var.web_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "business_subnet" {
  name                 = "${var.business_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.shared_vnet.name}"
  address_prefix       = "${var.business_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.db_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.shared_vnet.name}"
  address_prefix       = "${var.db_subnet_prefix}"
}

#NSGs
# Create network securirty group
resource "azurerm_network_security_group" "allow_all_nsg" {
  name                = "${var.allow_all_nsg_name}"
  location            = "${var.test_vm_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.test_vm_resource_group.name}"

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
resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.web_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.allow_all_nsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "business_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.business_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.allow_all_nsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.db_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.allow_all_nsg.id}"
}

# Route Tables
resource "azurerm_route_table" "business_route_table" {
  name                          = "AzureRefArch-transit-Business"
  location                      = "${azurerm_resource_group.shared_resource_group.location}"
  resource_group_name           = "${azurerm_resource_group.shared_resource_group.name}"
  disable_bgp_route_propagation = true

  route {
    name           = "Backdoor"
    address_prefix = "73.229.177.164/32"
    next_hop_type  = "Internet"
  }

  route {
    name           = "Blackhole-Management"
    address_prefix = "10.255.255.0/24"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.5.1.0"
    address_prefix         = "10.5.1.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-10.5.3.0"
    address_prefix         = "10.5.3.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-192.168.1.0"
    address_prefix         = "192.168.1.0/24"
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
}

resource "azurerm_subnet_route_table_association" "business_route_table_assoc" {
  subnet_id      = "${azurerm_subnet.business_subnet.id}"
  route_table_id = "${azurerm_route_table.business_route_table.id}"
}

resource "azurerm_route_table" "db_route_table" {
  name                          = "AzureRefArch-transit-DB"
  location                      = "${azurerm_resource_group.shared_resource_group.location}"
  resource_group_name           = "${azurerm_resource_group.shared_resource_group.name}"
  disable_bgp_route_propagation = true

  route {
    name           = "Backdoor"
    address_prefix = "73.229.177.164/32"
    next_hop_type  = "Internet"
  }

  route {
    name           = "Blackhole-Management"
    address_prefix = "10.255.255.0/24"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.5.1.0"
    address_prefix         = "10.5.1.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-10.5.2.0"
    address_prefix         = "10.5.2.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-192.168.1.0"
    address_prefix         = "192.168.1.0/24"
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
}

resource "azurerm_subnet_route_table_association" "db_route_table_assoc" {
  subnet_id      = "${azurerm_subnet.db_subnet.id}"
  route_table_id = "${azurerm_route_table.db_route_table.id}"
}

resource "azurerm_route_table" "web_route_table" {
  name                          = "AzureRefArch-transit-Web"
  location                      = "${azurerm_resource_group.shared_resource_group.location}"
  resource_group_name           = "${azurerm_resource_group.shared_resource_group.name}"
  disable_bgp_route_propagation = false

  route {
    name           = "Backdoor"
    address_prefix = "73.229.177.164/32"
    next_hop_type  = "Internet"
  }

  route {
    name           = "Blackhole-Management"
    address_prefix = "10.255.255.0/24"
    next_hop_type  = "None"
  }

  route {
    name                   = "Net-10.5.2.0"
    address_prefix         = "10.5.2.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-10.5.3.0"
    address_prefix         = "10.5.3.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.21"
  }

  route {
    name                   = "Net-192.168.1.0"
    address_prefix         = "192.168.1.0/24"
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
}

resource "azurerm_subnet_route_table_association" "web_route_table_assoc" {
  subnet_id      = "${azurerm_subnet.web_subnet.id}"
  route_table_id = "${azurerm_route_table.web_web_route_table.id}"
}

# Create the public ip for web test vm
resource "azurerm_public_ip" "web_test_publicip" {
  name                = "${var.web_test_publicip_name}"
  location            = "${var.testvm_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.test_vm_resource_group.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.web_test_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the public ip for db test vm
resource "azurerm_public_ip" "db_test_publicip" {
  name                = "${var.db_test_publicip_name}"
  location            = "${var.testvm_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.test_vm_resource_group.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.db_test_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Create the public ip for business
resource "azurerm_public_ip" "business_test_publicip" {
  name                = "${var.business_test_publicip_name}"
  location            = "${var.testvm_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.test_vm_resource_group.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.business_test_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interface for web test
resource "azurerm_network_interface" "web_test_nic0" {
  name                = "WebTestVM"
  resource_group_name = "${var.testvm_resource_group_name}"
  location            = "${var.testvm_resource_group_location}"

  ip_configuration {
    name                          = "web-test-nic0-ipconfig"
    subnet_id                     = "${azurerm_subnet.web_subnet.id}"
    private_ip_address_allocation = "Dynamic"

    # private_ip_address            = "${var.panorama1_vnic0_private_ip}"
    public_ip_address_id = "${azurerm_public_ip.web_test_publicip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interface for db test
resource "azurerm_network_interface" "db_test_nic0" {
  name                = "db-test-nic0-ipconfig"
  resource_group_name = "${var.testvm_resource_group_name}"
  location            = "${var.testvm_resource_group_location}"

  ip_configuration {
    name                          = "db-test-nic0-ipconfig"
    subnet_id                     = "${azurerm_subnet.db_subnet.id}"
    private_ip_address_allocation = "Dynamic"

    # private_ip_address            = "${var.panorama2_vnic0_private_ip}"
    public_ip_address_id = "${azurerm_public_ip.db_test_publicip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create network interface for business test
resource "azurerm_network_interface" "business_test_nic0" {
  name                = "business-test-nic0-ipconfig"
  resource_group_name = "${var.testvm_resource_group_name}"
  location            = "${var.testvm_resource_group_location}"

  ip_configuration {
    name                          = "business-test-nic0-ipconfig"
    subnet_id                     = "${azurerm_subnet.business_subnet.id}"
    private_ip_address_allocation = "Dynamic"

    # private_ip_address            = "${var.panorama2_vnic0_private_ip}"
    public_ip_address_id = "${azurerm_public_ip.business_test_publicip.id}"
  }

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create VMs
# Web Test VM
resource "azurerm_virtual_machine" "web_test_vm" {
  name                          = "${var.web_test_1vm_name}"
  location                      = "${var.testvm_resource_group_location}"
  resource_group_name           = "${var.testvm_resource_group_name}"
  network_interface_ids         = ["${azurerm_network_interface.web_test_nic0.id}"]
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

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# DB Test VM
resource "azurerm_virtual_machine" "db_test_vm" {
  name                          = "${var.db_test_1vm_name}"
  location                      = "${var.testvm_resource_group_location}"
  resource_group_name           = "${var.testvm_resource_group_name}"
  network_interface_ids         = ["${azurerm_network_interface.db_test_nic0.id}"]
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

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

# Business Test VM
resource "azurerm_virtual_machine" "business_test_vm" {
  name                          = "${var.business_test_1vm_name}"
  location                      = "${var.testvm_resource_group_location}"
  resource_group_name           = "${var.testvm_resource_group_name}"
  network_interface_ids         = ["${azurerm_network_interface.business_test_nic0.id}"]
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

  tags = {
    environment = "${var.environment_tag_name}"
  }
}
