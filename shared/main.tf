## Provider
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "1.23.0"
  subscription_id = "${var.subscription_id}"
}

## Shared Infrastructure
# Create Shared Resource Group
resource "azurerm_resource_group" "shared_resource_group" {
  name     = "${var.shared_resource_group_name}"
  location = "${var.shared_resource_group_location}"
}

# Create a vnet within the resource group
resource "azurerm_virtual_network" "refarch_vnet" {
  name                = "${var.refarch_vnet_name}"
  address_space       = ["${var.refarch_shared_address_space}", "${var.refarch_shrd_ext_address_space}", "${var.refarch_shrd_address_space}"]
  location            = "${azurerm_resource_group.shared_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"

  tags {
    environment = "${var.environment_tag_name}"
  }
}

# Create subnet within the vnet
resource "azurerm_subnet" "managment_subnet" {
  name                 = "${var.managment_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.refarch_vnet.name}"
  address_prefix       = "${var.managment_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "shared_public_subnet" {
  name                 = "${var.shared_public_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.refarch_vnet.name}"
  address_prefix       = "${var.shared_public_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "shared_private_subnet" {
  name                 = "${var.shared_private_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.refarch_vnet.name}"
  address_prefix       = "${var.shared_private_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "shared_web_subnet" {
  name                 = "${var.shared_web_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.refarch_vnet.name}"
  address_prefix       = "${var.shared_web_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "shared_business_subnet" {
  name                 = "${var.shared_business_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.refarch_vnet.name}"
  address_prefix       = "${var.shared_business_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "shared_db_subnet" {
  name                 = "${var.shared_db_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.refarch_vnet.name}"
  address_prefix       = "${var.shared_db_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "shared_vpn_subnet" {
  name                 = "${var.shared_vpn_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.refarch_vnet.name}"
  address_prefix       = "${var.shared_vpn_subnet_prefix}"
}

# Create subnet within the vnet
resource "azurerm_subnet" "sharedgwsubnet" {
  name                 = "${var.shared_gw_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.shared_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.refarch_vnet.name}"
  address_prefix       = "${var.shared_gw_subnet_prefix}"
}

# Create network securirty group
resource "azurerm_network_security_group" "management_nsg" {
  name                = "${var.management_nsg_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"

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
resource "azurerm_network_security_group" "shared_fw_pub_nsg" {
  name                = "${var.shared_fw_pub_nsg_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"

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
resource "azurerm_network_security_group" "shared_allow_all_nsg" {
  name                = "${var.shared_allow_all_nsg_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"

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
resource "azurerm_subnet_network_security_group_association" "managment_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.managment_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.management_nsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "shared_public_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.shared_public_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.shared_fw_pub_nsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "shared_private_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.shared_private_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.shared_allow_all_nsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "shared_web_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.shared_web_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.shared_allow_all_nsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "shared_business_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.shared_business_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.shared_allow_all_nsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "shared_db_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.shared_db_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.shared_allow_all_nsg.id}"
}

# Associate the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "shared_vpn_subnet_nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.shared_vpn_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.shared_allow_all_nsg.id}"
}

## Create route tables
resource "azurerm_route_table" "management_route_table" {
  name                          = "management_route_table"
  location                      = "${azurerm_resource_group.shared_resource_group.location}"
  resource_group_name           = "${azurerm_resource_group.shared_resource_group.name}"
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

resource "azurerm_subnet_route_table_association" "management_route_table_Assoc" {
  subnet_id      = "${azurerm_subnet.managment_subnet.id}"
  route_table_id = "${azurerm_route_table.management_route_table.id}"
}

resource "azurerm_route_table" "business_route_table" {
  name                          = "business_route_table"
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

resource "azurerm_subnet_route_table_association" "business_route_table_assoc" {
  subnet_id      = "${azurerm_subnet.shared_business_subnet.id}"
  route_table_id = "${azurerm_route_table.business_route_table.id}"
}

resource "azurerm_route_table" "db_route_table" {
  name                          = "db_route_table"
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

resource "azurerm_subnet_route_table_association" "db_route_table_assoc" {
  subnet_id      = "${azurerm_subnet.shared_db_subnet.id}"
  route_table_id = "${azurerm_route_table.db_route_table.id}"
}

resource "azurerm_route_table" "web_route_table" {
  name                          = "web_route_table"
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

resource "azurerm_subnet_route_table_association" "web_route_table_assoc" {
  subnet_id      = "${azurerm_subnet.shared_web_subnet.id}"
  route_table_id = "${azurerm_route_table.web_route_table.id}"
}

resource "azurerm_route_table" "private_route_table" {
  name                          = "private_route_table"
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

resource "azurerm_subnet_route_table_association" "private_route_table_assoc" {
  subnet_id      = "${azurerm_subnet.shared_private_subnet.id}"
  route_table_id = "${azurerm_route_table.private_route_table.id}"
}

resource "azurerm_route_table" "public_route_table" {
  name                          = "public_route_table"
  location                      = "${azurerm_resource_group.shared_resource_group.location}"
  resource_group_name           = "${azurerm_resource_group.shared_resource_group.name}"
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

resource "azurerm_subnet_route_table_association" "public_route_table_assoc" {
  subnet_id      = "${azurerm_subnet.shared_public_subnet.id}"
  route_table_id = "${azurerm_route_table.public_route_table.id}"
}

## Load Balancers
# Create the Public IP Address for the frontend IP address for Azure Public Load-Balancer
resource "azurerm_public_ip" "public_lb_frontend_ip" {
  name                = "${var.public_lb_frontend_ip_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${var.public_lb_domain_name_label}"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

## Create LB backend pool
resource "azurerm_lb_backend_address_pool" "public_lb_backend_address_pool" {
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.public_lb.id}"
  name                = "${var.public_lb_backend_pool_name}"
}

## Create Public Load Balancer
resource "azurerm_lb" "public_lb" {
  name                = "${var.public_lb_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.public_lb_frontend_ip_name}"
    public_ip_address_id = "${azurerm_public_ip.public_lb_frontend_ip.id}"
  }
}

resource "azurerm_lb_probe" "public_https_probe" {
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.public_lb.id}"
  name                = "HTTPS-Probe"
  port                = 443
}

resource "azurerm_lb_rule" "shared_public_web_22" {
  resource_group_name            = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.public_lb.id}"
  name                           = "Shared-Public-Web-80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.public_lb_frontend_ip_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"
  probe_id                       = "${azurerm_lb_probe.public_https_probe.id}"
  enable_floating_ip             = "True"
}

resource "azurerm_lb_rule" "shared_public_web_80" {
  resource_group_name            = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.public_lb.id}"
  name                           = "Shared-Public-Web-80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.public_lb_frontend_ip_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"
  probe_id                       = "${azurerm_lb_probe.public_https_probe.id}"
  enable_floating_ip             = "True"
}

resource "azurerm_lb_rule" "shared_public_web_443" {
  resource_group_name            = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.public_lb.id}"
  name                           = "Shared-Public-Web-443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${var.public_lb_frontend_ip_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.public_lb_backend_address_pool.id}"
  probe_id                       = "${azurerm_lb_probe.public_https_probe.id}"
  enable_floating_ip             = "True"
}

## Create LB Internal backend pool
resource "azurerm_lb_backend_address_pool" "internal_lb_backend_address_pool" {
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal_lb.id}"
  name                = "${var.internal_lb_backend_pool_name}"
}

## Create LB Internal Public backend pool
resource "azurerm_lb_backend_address_pool" "internal_public_lb_backend_address_pool" {
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal_lb.id}"
  name                = "${var.internal_Public_lb_backend_pool_name}"
}

## Create LB VPN backend pool
resource "azurerm_lb_backend_address_pool" "vpn_lb_backend_address_pool" {
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal_lb.id}"
  name                = "${var.vpn_lb_backend_pool_name}"
}

## Create Internal LB
resource "azurerm_lb" "internal_lb" {
  name                = "${var.internal_lb_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "${var.internal_lb_frontend_ip_name}"
    private_ip_address            = "${var.internal_lb_frontend_ip}"
    private_ip_address_allocation = "Static"
    subnet_id                     = "${azurerm_subnet.shared_private_subnet.id}"
  }

  frontend_ip_configuration {
    name                          = "${var.internal_public_lb_frontend_ip_name}"
    private_ip_address            = "${var.internal_public_lb_frontend_ip}"
    private_ip_address_allocation = "Static"
    subnet_id                     = "${azurerm_subnet.shared_public_subnet.id}"
  }

  frontend_ip_configuration {
    name                          = "${var.vpn_lb_frontend_ip_name}"
    private_ip_address            = "${var.vpn_lb_frontend_ip}"
    private_ip_address_allocation = "Static"
    subnet_id                     = "${azurerm_subnet.shared_vpn_subnet.id}"
  }
}

resource "azurerm_lb_probe" "internal_https_probe" {
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal_lb.id}"
  name                = "HTTPS-Probe"
  port                = 443
}

resource "azurerm_lb_rule" "shared_private_all_ports" {
  resource_group_name            = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.internal_lb.id}"
  name                           = "Shared-Private-All-Ports"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "${var.internal_lb_frontend_ip_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.internal_lb_backend_address_pool.id}"
  probe_id                       = "${azurerm_lb_probe.internal_https_probe.id}"
  enable_floating_ip             = "True"
}

resource "azurerm_lb_rule" "shared_public_all_ports" {
  resource_group_name            = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.internal_lb.id}"
  name                           = "Shared-Public-All-Ports"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "${var.internal_public_lb_frontend_ip_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.internal_public_lb_backend_address_pool.id}"
  probe_id                       = "${azurerm_lb_probe.internal_https_probe.id}"
  enable_floating_ip             = "True"
}

resource "azurerm_lb_rule" "shared_vpn_all_ports" {
  resource_group_name            = "${azurerm_resource_group.shared_resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.internal_lb.id}"
  name                           = "Shared-VPN-All-Ports"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "${var.vpn_lb_frontend_ip_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.vpn_lb_backend_address_pool.id}"
  probe_id                       = "${azurerm_lb_probe.internal_https_probe.id}"
  enable_floating_ip             = "True"
}
