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
  default = "Unit-10-PAN-RefArch"
}

variable "shared_resource_group_location" {
  default = "centralus"
}

variable "refarch_vnet_name" {
  default = "Unit-10-PAN-RefArch-VNET"
}

variable "refarch_shared_address_space" {
  default = "10.255.255.0/24"
}

variable "refarch_shrd_ext_address_space" {
  default = "172.16.0.0/23"
}

variable "refarch_shrd_address_space" {
  default = "10.5.0.0/16"
}

variable "shared_subnet_prefix" {
  default = "10.255.255.0/24"
}

variable "shared_nsg_name" {
  default = "AllowManagement-Subnet"
}

variable "shared_allow_all_nsg_name" {
  default = "AllowAll-Subnet"
}

variable "shared_fw_pub_nsg_name" {
  default = "Firewall-Public-Interface"
}

variable "shared_subnet_name" {
  default = "Management"
}

variable "shared_public_subnet_name" {
  default = "Shared-Public"
}

variable "shared_public_subnet_prefix" {
  default = "172.16.1.0/24"
}

variable "shared_private_subnet_name" {
  default = "Shared-Private"
}

variable "shared_private_subnet_prefix" {
  default = "10.5.0.0/24"
}

variable "shared_web_subnet_name" {
  default = "Shared-Web"
}

variable "shared_web_subnet_prefix" {
  default = "10.5.1.0/24"
}

variable "shared_business_subnet_name" {
  default = "Shared-Business"
}

variable "shared_business_subnet_prefix" {
  default = "10.5.2.0/24"
}

variable "shared_db_subnet_name" {
  default = "Shared-DB"
}

variable "shared_db_subnet_prefix" {
  default = "10.5.3.0/24"
}

variable "shared_vpn_subnet_name" {
  default = "Shared-VPN"
}

variable "shared_vpn_subnet_prefix" {
  default = "10.5.15.0/24"
}

variable "shared_gw_subnet_name" {
  default = "GatewaySubnet"
}

variable "shared_gw_subnet_prefix" {
  default = "10.5.40.0/24"
}

# ## Panorama vars
# variable "panorama1_shared_public_ip_name" {
#   default = "10M-Dev-Azure-Panorama-1-PIP"
# }
#
# variable "panorama1_shared_domain_name_label" {
#   default = "xm-dev-panorama-1"
# }
#
# variable "panorama1_vm_name" {
#   default = "10M-Dev-Azure-Panorama-1"
# }
#
# variable "panorama1_vnic0_name" {
#   default = "azure-panorama1-VNIC0"
# }
#
# variable "panorama1_vnic0_private_ip" {
#   default = "10.255.255.4"
# }
#
# variable "panorama1_os_disk_account_name" {
#   default = "panorama1osdisk"
# }
#
# variable "panorama2_shared_public_ip_name" {
#   default = "10M-Dev-Azure-Panoram-2-PIP"
# }
#
# variable "panorama2_shared_domain_name_label" {
#   default = "xm-dev-panorama-2"
# }
#
# variable "panorama2_vm_name" {
#   default = "10M-Dev-Azure-Panorama-2"
# }
#
# variable "panorama2_vnic0_name" {
#   default = "azure-panorama2-VNIC0"
# }
#
# variable "panorama2_vnic0_private_ip" {
#   default = "10.255.255.5"
# }
#
# variable "panorama2_os_disk_account_name" {
#   default = "panorama2osdisk"
# }
#
# variable "panorama_avail_set_name" {
#   default = "DevAzureRefArch-AS"
# }
#
# variable "panorama_storage_acct_name" {
#   default = "xmdevazurerefarchpandiag"
# }
#
# variable "panorama_vm_size" {
#   default = "Standard_DS3_v2"
# }
#
# variable "panoramaSku" {
#   default = "byol"
# }
#
# variable "panoramaOffer" {
#   default = "panorama"
# }
#
# variable "panoramaPublisher" {
#   default = "paloaltonetworks"
# }

