terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.6.0"
    }
    github = {
      source = "integrations/github"
      version = "=6.13.0"
    }
  }
}