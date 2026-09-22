terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=3.9.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.6.0"
    }
    github = {
      source  = "integrations/github"
      version = "=6.13.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.9.1"
    }
  }
}
