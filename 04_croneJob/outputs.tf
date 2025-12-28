output "function_app_name" {
  description = "The name of the Azure Function App"
  value       = azurerm_linux_function_app.function.name
}

output "function_app_resource_group" {
  description = "The resource group of the Azure Function App"
  value       = azurerm_linux_function_app.function.resource_group_name
}

output "function_app_default_host_name" {
  description = "The default hostname of the Function App"
  value       = azurerm_linux_function_app.function.default_hostname
}
