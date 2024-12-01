terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.71.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4.0"
    }
  }

  backend "azurerm" {}
}
