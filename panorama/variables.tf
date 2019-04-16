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
  default = "10M DevAzureRefArch Terraform Demo"
}

variable "admin_username" {
  default = "xmrefarchadmin"
}

variable "admin_password" {
  default = "s0wqLK0N5f0!"
}

variable "panorama_resource_group_name" {
  default = "Unit-10-PAN-RefArch-Panorama"
}

variable "panorama_resource_group_location" {
  default = "centralus"
}

variable "panorama_subnet_name" {
  default = "Management"
}

## Panorama vars
variable "panorama1_panorama_public_ip_name" {
  default = "Unit-10-PAN-RefArch-1-PIP"
}

variable "panorama1_panorama_domain_name_label" {
  default = "unit-10-pan-refarch-panorama-1"
}

variable "panorama1_vm_name" {
  default = "Unit-10-PAN-RefArch-Panorama-1"
}

variable "panorama1_vnic0_name" {
  default = "azure-panorama1-VNIC0"
}

variable "panorama1_vnic0_private_ip" {
  default = "10.255.255.4"
}

variable "panorama1_os_disk_account_name" {
  default = "panorama1osdisk"
}

variable "panorama2_panorama_public_ip_name" {
  default = "Unit-10-PAN-RefArch-2-PIP"
}

variable "panorama2_panorama_domain_name_label" {
  default = "unit-10-pan-refarch-panorama-2"
}

variable "panorama2_vm_name" {
  default = "Unit-10-PAN-RefArch-Panorama-2"
}

variable "panorama2_vnic0_name" {
  default = "azure-panorama2-VNIC0"
}

variable "panorama2_vnic0_private_ip" {
  default = "10.255.255.5"
}

variable "panorama2_os_disk_account_name" {
  default = "panorama2osdisk"
}

variable "panorama_avail_set_name" {
  default = "Unit-10-PAN-RefArch-AS"
}

variable "panorama_storage_acct_name" {
  default = "unit10panrefarchdiag"
}

variable "panorama_vm_size" {
  default = "Standard_DS3_v2"
}

variable "panoramaSku" {
  default = "byol"
}

variable "panoramaOffer" {
  default = "panorama"
}

variable "panoramaPublisher" {
  default = "paloaltonetworks"
}
