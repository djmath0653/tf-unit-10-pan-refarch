## Variables used to deploy PAN Unit-10-PAN-RefArch
# Environment vars
variable "provider_version" {
  default = "1.23.0"
}

variable "subscription_id" {
  default = "7ef81faa-9186-4af3-b97c-71f4e517266f"
}

variable "shared_vnet_name" {
  default = "Unit-10-PAN-RefArch-VNET"
}

variable "shared_resource_group_name" {
  default = "Unit-10-PAN-RefArch-Shared"
}

variable "testvm_resource_group_name" {
  default = "Unit-10-PAN-RefArch-TestVMs"
}

variable "testvm_resource_group_location" {
  default = "centralus"
}

variable "azure_refarch_vnet_name" {
  default = "Unit-10-PAN-RefArch-VNET"
}

variable "environment_tag_name" {
  default = "Unit 10 PAN Referece Architecture"
}

variable "web_subnet_name" {
  default = "Shared-Web"
}

variable "web_subnet_prefix" {
  default = "10.5.1.0/24"
}

variable "business_subnet_name" {
  default = "Shared-Business"
}

variable "business_subnet_prefix" {
  default = "10.5.2.0/24"
}

variable "db_subnet_name" {
  default = "Shared-DB"
}

variable "db_subnet_prefix" {
  default = "10.5.3.0/24"
}

variable "admin_username" {
  default = "xmrefarchadmin"
}

variable "admin_password" {
  default = "s0wqLK0N5f0!"
}

#
# variable "shared_web_subnet_name" {
#   default = "Shared-Web"
# }
#
# variable "shared_db_subnet_name" {
#   default = "Shared-DB"
# }
#
# variable "shared_business_subnet_name" {
#   default = "Shared-Business"
# }

variable "web_test_publicip_name" {
  default = "Unit-10-PAN-RefArch-Web-VM-PIP"
}

variable "web_test_domain_name_label" {
  default = "unit-10-pan-refarch-web-test"
}

variable "db_test_publicip_name" {
  default = "Unit-10-PAN-RefArch-DB-VM-PIP"
}

variable "db_test_domain_name_label" {
  default = "unit-10-pan-refarch-db-test"
}

variable "business_test_publicip_name" {
  default = "Unit-10-PAN-RefArch-Business-VM-PIP"
}

variable "business_test_domain_name_label" {
  default = "unit-10-pan-refarch-business-test"
}

variable "web_test_1vm_name" {
  default = "Unit-10-PAN-RefArch-webtestvm"
}

variable "db_test_1vm_name" {
  default = "Unit-10-PAN-RefArch-dbtestvm"
}

variable "business_test_1vm_name" {
  default = "Unit-10-PAN-RefArch-businesstestvm"
}
