## Provider
# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "1.23.0"
  subscription_id = "${var.subscription_id}"
}

## VPN Infrastructure
# Create AzureRefArch VPN Resource Group

resource "azurerm_resource_group" "vpn_resource_group" {
  name     = "${var.vpn_resource_group_name}"
  location = "${var.vpn_resource_group_location}"
}

data "azurerm_resource_group" "shared_resource_group" {
  name = "${var.shared_resource_group_name}"
}

# get data from vpn subnet
data "azurerm_subnet" "shared_vpn_subnet" {
  name                 = "${var.shared_vpn_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.shared_resource_group_name}"
}

# get data from gw subnet
data "azurerm_subnet" "shared_gw_subnet" {
  name                 = "${var.shared_gw_subnet_name}"
  virtual_network_name = "${var.azure_refarch_vnet_name}"
  resource_group_name  = "${var.shared_resource_group_name}"
}

# Create the public ip for VPN GW
resource "azurerm_public_ip" "vpn_gw_public_ip" {
  name                = "${var.vpn_gw_public_ip_name}"
  location            = "${var.vpn_resource_group_location}"
  resource_group_name = "${data.azurerm_resource_group.shared_resource_group.name}"
  sku                 = "Basic"
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.environment_tag_name}"
  }
}

resource "azurerm_virtual_network_gateway" "vng" {
  name                = "${var.vng_name}"
  location            = "${data.azurerm_resource_group.shared_resource_group.location}"
  resource_group_name = "${data.azurerm_resource_group.shared_resource_group.name}"
  type                = "Vpn"
  vpn_type            = "RouteBased"
  enable_bgp          = true
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.vpn_gw_public_ip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${data.azurerm_subnet.shared_gw_subnet.id}"
  }

  bgp_settings {
    asn             = "65515"
    peering_address = "10.6.1.255"
  }

  #   vpn_client_configuration {
  #     address_space = ["10.6.0.0/24"]
  #   }
}

resource "azurerm_local_network_gateway" "lng" {
  name                = "${var.lng_name}"
  location            = "${var.shared_resource_group_location}"
  resource_group_name = "${data.azurerm_resource_group.shared_resource_group.name}"
  gateway_address     = "${var.lng_ip}"
  address_space       = ["10.6.1.255/32"]
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                       = "${var.vpn_connection_name}"
  location                   = "${var.shared_resource_group_location}"
  resource_group_name        = "${data.azurerm_resource_group.shared_resource_group.name}"
  type                       = "IPsec"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.vng.id}"
  local_network_gateway_id   = "${azurerm_local_network_gateway.lng.id}"
  shared_key                 = "xGc2Uz9oE&4q"
}
