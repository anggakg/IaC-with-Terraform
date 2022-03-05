terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.98.0"
    }
  }
  backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "tfstate22081"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}