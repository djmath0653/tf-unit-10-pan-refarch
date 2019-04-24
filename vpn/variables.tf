## Variables used to deploy PAN DevAzureRefArch
# Environment vars
variable "provider_version" {
  default = "1.23.0"
}

# variable "subscription_id" {
#   default = "8a8c41b2-759f-44cd-8b34-0fbb900b0301"
# }

variable "subscription_id" {
  default = "7ef81faa-9186-4af3-b97c-71f4e517266f"
}

variable "environment_tag_name" {
  default = "Unit 10 PAN Referece Architecture"
}

variable "admin_username" {
  default = "xmrefarchadmin"
}

variable "admin_password" {
  default = "s0wqLK0N5f0!"
}

variable "shared_resource_group_name" {
  default = "Unit-10-PAN-RefArch-Shared"
}

variable "shared_resource_group_location" {
  default = "centralus"
}

variable "shared_vpn_subnet_name" {
  default = "Shared-VPN"
}

variable "shared_gw_subnet_name" {
  default = "GatewaySubnet"
}

variable "vpn_resource_group_name" {
  default = "Unit-10-PAN-RefArch-VPN"
}

variable "vpn_resource_group_location" {
  default = "westus"
}

variable "azure_refarch_vnet_name" {
  default = "Unit-10-PAN-RefArch-VNET"
}

variable "vpn_gw_public_ip_name" {
  default = "10M-Azure-vpn-gw-PIP"
}

variable "vng_name" {
  default = "Unit-10-PAN-RefArch-VNG"
}

variable "lng_name" {
  default = "Unit-10-PAN-RefArch-LNG-OnPrem"
}

variable "lng_ip" {
  default = "73.229.177.164"
}

variable "vpn_connection_name" {
  default = "Unit-10-PAN-RefArch-LNG-OnPrem"
}
