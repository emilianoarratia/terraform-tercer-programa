output "resource_group_name" {
  value = azurerm_resource_group.qa.name
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.qa.name
}

output "application_insights_name" {
  value = azurerm_application_insights.qa.name
}

output "service_plan_name" {
  value = azurerm_service_plan.qa.name
}

output "web_app_name" {
  value = azurerm_linux_web_app.qa.name
}

output "web_app_url" {
  value = "https://${azurerm_linux_web_app.qa.default_hostname}"
}
