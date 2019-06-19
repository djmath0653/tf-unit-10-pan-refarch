## Variables used to deploy PAN DevAzureARA-Shared
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
  default = "Unit-10-PAN-ARA-Shared-RG"
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
  default = "Unit-10-PAN-ARA-Shared-VPN"
}

variable "vpn_resource_group_location" {
  default = "centralus"
}

variable "azure_refarch_vnet_name" {
  default = "Unit-10-PAN-ARA-Shared-VNET"
}

variable "vpn_gw_public_ip_name" {
  default = "Unit-10-PAN-ARA-Shared-vpn-gw-PIP"
}

variable "vng_name" {
  default = "Unit-10-PAN-ARA-Shared-VNG"
}

variable "lng_name" {
  default = "Unit-10-PAN-ARA-Shared-LNG-OnPrem"
}

variable "lng_ip" {
  default = "73.229.177.164"
}

variable "vpn_connection_name" {
  default = "Unit-10-PAN-ARA-Shared-LNG-OnPrem"
}
