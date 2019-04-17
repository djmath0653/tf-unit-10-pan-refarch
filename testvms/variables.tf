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

variable "mgmt_resource_group_name" {
  default = "DevAzureRefArch-Management"
}

variable "shared_resource_group_name" {
  default = "DevAzureRefArch-Shared"
}

variable "shared_resource_group_location" {
  default = "westus"
}

variable "testvm_resource_group_name" {
  default = "DevAzureRefArch-TestVMs"
}

variable "testvm_resource_group_location" {
  default = "westus"
}

variable "azure_refarch_vnet_name" {
  default = "DevAzureRefArch-VNET"
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
  default = "10M-Dev-Azure-Web-Test-PIP"
}

variable "web_test_domain_name_label" {
  default = "xm-dev-web-test"
}

variable "db_test_publicip_name" {
  default = "10M-Dev-Azure-DB-Test-PIP"
}

variable "db_test_domain_name_label" {
  default = "xm-dev-db-test"
}

variable "business_test_publicip_name" {
  default = "10M-Dev-Azure-Business-Test-PIP"
}

variable "business_test_domain_name_label" {
  default = "xm-dev-business-test"
}

variable "web_test_1vm_name" {
  default = "10M-Dev-Azure-webtestvm"
}

variable "db_test_1vm_name" {
  default = "10M-Dev-Azure-dbtestvm"
}

variable "business_test_1vm_name" {
  default = "10M-Dev-Azure-businesstestvm"
}
