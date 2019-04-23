## Variables used to deploy PAN Unit-10-PAN-RefArch
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

variable "shared_resource_group_name" {
  default = "Unit-10-PAN-RefArch-Shared"
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

variable "managment_subnet_name" {
  default = "Management"
}

variable "managment_subnet_prefix" {
  default = "10.255.255.0/24"
}

variable "management_nsg_name" {
  default = "AllowManagement-Subnet"
}

variable "shared_allow_all_nsg_name" {
  default = "AllowAll-Subnet"
}

variable "shared_fw_pub_nsg_name" {
  default = "Firewall-Public-Interface"
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

variable "public_lb_frontend_ip_name" {
  default = "Unit-10-PAN-RefArch-Public-LB-IP"
}

variable "public_lb_domain_name_label" {
  default = "unit-10-pan-refarch-public-lb-ip"
}

variable "public_lb_name" {
  default = "Unit-10-PAN-RefArch-Shared-Public"
}

variable "internal_lb_name" {
  default = "Unit-10-PAN-RefArch-Shared-Internal"
}

variable "internal_lb_frontend_ip_name" {
  default = "LoadBalancerFrontEnd"
}

variable "internal_lb_frontend_ip" {
  default = "10.5.0.21"
}

variable "internal_public_lb_frontend_ip_name" {
  default = "Internal-Frontend-Public"
}

variable "internal_public_lb_frontend_ip" {
  default = "172.16.1.21"
}

variable "vpn_lb_frontend_ip_name" {
  default = "Internal-Frontend-VPN"
}

variable "vpn_lb_frontend_ip" {
  default = "10.5.15.21"
}
