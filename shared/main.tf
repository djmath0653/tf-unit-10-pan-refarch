## Provider
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "1.23.0"
  subscription_id = "${var.subscription_id}"
}

## Shared Infrastructure
# Create Shared Resource Group
resource "azurerm_resource_group" "shared-resource-group" {
  name     = "${var.shared-resource-group_name}"
  location = "${var.shared-resource-group_location}"
}

# Create a vnet within the resource group
resource "azurerm_virtual_network" "refarch_vnet" {
  name                = "${var.refarch_vnet_name}"
  address_space       = ["${var.refarch_shared_address_space}", "${var.refarch_shrd_ext_address_space}", "${var.refarch_shrd_address_space}"]
  location            = "${azurerm_resource_group.shared-resource-group.location}"
  resource_group_name = "${azurerm_resource_group.shared-resource-group.name}"

  tags {
    environment = "${var.environment_tag_name}"
  }
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedsubnet" {
  name                 = "${var.shared_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedpublicsubnet" {
  name                 = "${var.shared_public_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_public_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedprivatesubnet" {
  name                 = "${var.shared_private_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_private_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedwebsubnet" {
  name                 = "${var.shared_web_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_web_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedbusinesssubnet" {
  name                 = "${var.shared_business_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_business_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "shareddbsubnet" {
  name                 = "${var.shared_db_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_db_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedvpnsubnet" {
  name                 = "${var.shared_vpn_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_vpn_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedgwsubnet" {
  name                 = "${var.shared_gw_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.azrefarchvnet.name}"
  address_prefix       = "${var.shared_gw_subnet_prefix}"
}

# Create network securirty group
resource "azurerm_network_security_group" "sharednsg" {
  name                = "${var.shared_nsg_name}"
  location            = "${var.shared-resource-group_location}"
  resource_group_name = "${azurerm_resource_group.shared-resource-group.name}"

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
  location            = "${var.shared-resource-group_location}"
  resource_group_name = "${azurerm_resource_group.shared-resource-group.name}"

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
  location            = "${var.shared-resource-group_location}"
  resource_group_name = "${azurerm_resource_group.shared-resource-group.name}"

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
resource "azurerm_subnet_network_security_group_association" "sharedsubnetnsgassoc" {
  subnet_id                 = "${azurerm_subnet.sharedsubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.sharednsg.id}"
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
  location                      = "${azurerm_resource_group.shared-resource-group.location}"
  resource_group_name           = "${azurerm_resource_group.shared-resource-group.name}"
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
  subnet_id      = "${azurerm_subnet.sharedsubnet.id}"
  route_table_id = "${azurerm_route_table.AzureRefArch-Management.id}"
}

resource "azurerm_route_table" "AzureRefArch-Shared-Business" {
  name                          = "AzureRefArch-Shared-Business"
  location                      = "${azurerm_resource_group.shared-resource-group.location}"
  resource_group_name           = "${azurerm_resource_group.shared-resource-group.name}"
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
  location                      = "${azurerm_resource_group.shared-resource-group.location}"
  resource_group_name           = "${azurerm_resource_group.shared-resource-group.name}"
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
  location                      = "${azurerm_resource_group.shared-resource-group.location}"
  resource_group_name           = "${azurerm_resource_group.shared-resource-group.name}"
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
  location                      = "${azurerm_resource_group.shared-resource-group.location}"
  resource_group_name           = "${azurerm_resource_group.shared-resource-group.name}"
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
  location                      = "${azurerm_resource_group.shared-resource-group.location}"
  resource_group_name           = "${azurerm_resource_group.shared-resource-group.name}"
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
resource "azurerm_public_ip" "panorama2_shared_publicip" {
  name                = "${var.panorama2_shared_public_ip_name}"
  location            = "${azurerm_resource_group.shared-resource-group.location}"
  resource_group_name = "${azurerm_resource_group.shared-resource-group.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.panorama2_shared_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}
