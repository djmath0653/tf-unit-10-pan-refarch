## Variables used to deploy PAN DevAzureRefArch-Shared Resource Group
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

variable "shared_resource_group_name" {
  default = "Unit-10-PAN-RefArch-Shared"
}

variable "shared_resource_group_location" {
  default = "centralus"
}

variable "refarch_vnet_name" {
  default = "Unit-10-PAN-RefArch-VNET"
}

variable "environment_tag_name" {
  default = "Unit 10 PAN Referece Architecture"
}

variable "firewall_resource_group_name" {
  default = "Unit-10-PAN-RefArch-Firewall"
}

variable "firewall_resource_group_location" {
  default = "centralus"
}

variable "mgmt_nsg_name" {
  default = "AllowManagement-Subnet"
}

variable "mgmt_subnet_name" {
  default = "Management"
}

variable "shared_public_subnet_name" {
  default = "Shared-Public"
}

variable "shared_private_subnet_name" {
  default = "Shared-Private"
}

variable "shared_vpn_subnet_name" {
  default = "Shared-VPN"
}

variable "shared_web_subnet_name" {
  default = "Shared-Web"
}

variable "shared_business_subnet_name" {
  default = "Shared-Business"
}

variable "shared_db_subnet_name" {
  default = "Shared-DB"
}

variable "public_lb_name" {
  default = "Unit-10-PAN-RefArch-Shared-Public"
}

variable "internal_lb_name" {
  default = "Unit-10-PAN-RefArch-Shared-Internal"
}

variable "public_lb_backend_pool_name" {
  default = "Firewall-Layer"
}

variable "internal_lb_backend_pool_name" {
  default = "Firewall-Layer-Private"
}

variable "internal_Public_lb_backend_pool_name" {
  default = "Firewall-Layer-Public"
}

variable "vpn_lb_backend_pool_name" {
  default = "Firewall-Layer-VPN"
}

## Firewall vars
variable "admin_username" {
  default = "xmrefarchadmin"
}

variable "admin_password" {
  default = "s0wqLK0N5f0!"
}

variable "shared_avail_set_name" {
  default = "Unit-10-PAN-RefArch-Firewall-AS"
}

variable "firewall_storage_acct_name" {
  default = "unit10panrefarchv2shared"
}

variable "firewall_vm_size" {
  description = "firewall VM Size"
  default     = "Standard_DS3_v2"
}

variable "firewallSku" {
  default = "bundle1"
}

variable "firewallOffer" {
  default = "vmseries1"
}

variable "firewallPublisher" {
  default = "paloaltonetworks"
}

variable "firewall1_mgmt_public_ip_name" {
  default = "Unit-10-PAN-RefArch-firewall-1-PIP"
}

variable "firewall1_mgmt_domain_name_label" {
  default = "unit-10-pan-refarch-firewall-1"
}

variable "firewall1_vm_name" {
  default = "Unit-10-PAN-RefArch-Firewall-1"
}

variable "firewall1_vnic0_name" {
  description = "firewall 1 Manamagement Interface"
  default     = "azure-firewall1-VNIC0"
}

variable "firewall1_vnic0_private_ip" {
  description = "firewall 1 Manamagement private ip"
  default     = "10.255.255.6"
}

variable "firewall1_vnic1_name" {
  description = "firewall 1 Public Interface"
  default     = "azure-firewall1-VNIC1"
}

variable "firewall1_vnic1_private_ip" {
  description = "firewall 1 Public private ip"
  default     = "172.16.1.6"
}

variable "firewall1_vnic2_name" {
  description = "firewall 1 Private Interface"
  default     = "azure-firewall1-VNIC2"
}

variable "firewall1_vnic2_private_ip" {
  description = "firewall 1 Public private ip"
  default     = "10.5.0.6"
}

variable "firewall1_vnic3_name" {
  description = "firewall 1 VPN Interface"
  default     = "azure-firewall1-VNIC3"
}

variable "firewall1_vnic3_private_ip" {
  description = "firewall 1 Public private ip"
  default     = "10.5.15.6"
}

variable "firewall1_os_disk_account_name" {
  default = "firewall1osdisk"
}

variable "firewall2_mgmt_public_ip_name" {
  default = "Unit-10-PAN-RefArch-Firewall-2-PIP"
}

variable "firewall2_mgmt_domain_name_label" {
  default = "unit-10-pan-refarch-firewall-2"
}

variable "firewall2_vm_name" {
  default = "Unit-10-PAN-RefArch-Firewall-2"
}

variable "firewall2_vnic0_name" {
  default = "azure-firewall2-VNIC0"
}

variable "firewall2_vnic0_private_ip" {
  default = "10.255.255.7"
}

variable "firewall2_vnic1_name" {
  default = "azure-firewall2-VNIC1"
}

variable "firewall2_vnic1_private_ip" {
  default = "172.16.1.7"
}

variable "firewall2_vnic2_name" {
  default = "azure-firewall2-VNIC2"
}

variable "firewall2_vnic2_private_ip" {
  default = "10.5.0.7"
}

variable "firewall2_vnic3_name" {
  default = "azure-firewall2-VNIC3"
}

variable "firewall2_vnic3_private_ip" {
  default = "10.5.15.7"
}

variable "firewall2_os_disk_account_name" {
  default = "firewall2osdisk"
}
