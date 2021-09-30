terraform {
  required_providers{
    azurerm ={
      source = "hashicorp/azurerm"
      version = "2.66.0"
    }
  }
}

provider "azurerm" {
  features {}
  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
} 

locals {
  environment=var.environment
  project_name="testazboot21"
  location="southafricanorth"
  tags = {

  }
}