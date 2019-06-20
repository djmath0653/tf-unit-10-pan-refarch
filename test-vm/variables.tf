## Variables used to deploy PAN Unit-10-PAN-ARA-Shared
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
  default = "Unit-10-PAN-ARA-Shared"
}

variable "testvm_resource_group_name" {
  default = "Unit-10-PAN-ARA-Shared-TestVM"
}

variable "testvm_resource_group_location" {
  default = "centralus"
}

variable "azure_refarch_vnet_name" {
  default = "Unit-10-PAN-ARA-Shared"
}

variable "shared_web_subnet_name" {
  default = "Shared-Web"
}

variable "shared_db_subnet_name" {
  default = "Shared-DB"
}

variable "shared_business_subnet_name" {
  default = "Shared-Business"
}

variable "web_test_publicip_name" {
  default = "Unit-10-PAN-ARA-Shared-Web-VM"
}

variable "web_test_domain_name_label" {
  default = "unit-10-pan-refarch-web"
}

variable "db_test_publicip_name" {
  default = "Unit-10-PAN-ARA-Shared-DB-VM"
}

variable "db_test_domain_name_label" {
  default = "unit-10-pan-refarch-db"
}

variable "business_test_publicip_name" {
  default = "Unit-10-PAN-ARA-Shared-Business-VM"
}

variable "business_test_domain_name_label" {
  default = "unit-10-pan-refarch-business"
}

variable "web_test_1vm_name" {
  default = "Unit-10-PAN-ARA-Shared-Web"
}

variable "db_test_1vm_name" {
  default = "Unit-10-PAN-ARA-Shared-DB"
}

variable "business_test_1vm_name" {
  default = "Unit-10-PAN-ARA-Shared-Business"
}
