terraform {
  backend "azurerm" {
    storage_account_name = "panaraterraform"
    container_name       = "terraform-state"
    key                  = "shared-shared.state"
    access_key           = "F4PssODHNxsGQvzQcmO5yK9Ixq8SKJsGeIFFR1c7JZWDTBQX+Aag3zX01SBVv7nt25C8pZGL5A5vT6xXj8I45Q=="
  }
}
