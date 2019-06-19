terraform {
  backend "azurerm" {
    storage_account_name = "unit10panrefarch"
    container_name       = "terraform-state"
    key                  = "shared-vpn.state"
    access_key           = "7N9tKzgmzyEEcndnD+yppUwDlCI65seqzaJ50dsFFlgSANbykDqevJbT3b/TQAG6uVMo3VXG0JwdoPknfQh2IA=="
  }
}
