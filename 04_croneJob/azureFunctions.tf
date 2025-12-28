terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}

resource "random_integer" "rand" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "terraform_class" {
  name     = "${var.vm_name}-group"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = lower("cronjobstorage${random_integer.rand.result}")
  resource_group_name      = azurerm_resource_group.terraform_class.name
  location                 = azurerm_resource_group.terraform_class.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "plan" {
  name                = "cronjob-plan"
  location            = azurerm_resource_group.terraform_class.location
  resource_group_name = azurerm_resource_group.terraform_class.name
  sku_name            = "Y1"  
  os_type             = "Linux"
}

resource "azurerm_linux_function_app" "function" {
  name                       = "my-cron-function"
  location                   = azurerm_resource_group.terraform_class.location
  resource_group_name        = azurerm_resource_group.terraform_class.name
  service_plan_id            = azurerm_service_plan.plan.id

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  site_config {
    application_stack {
      node_version = "20"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
    FUNCTIONS_EXTENSION_VERSION = "~4"
  }
}
