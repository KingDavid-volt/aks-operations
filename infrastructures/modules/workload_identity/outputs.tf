output "client_id" {
  description = "Client ID — put this in the ServiceAccount's azure.workload.identity/client-id annotation"
  value       = azurerm_user_assigned_identity.user_identity.client_id
}

output "principal_id" {
  description = "Principal (object) ID of the managed identity"
  value       = azurerm_user_assigned_identity.user_identity.principal_id
}

output "identity_id" {
  description = "Full resource ID of the managed identity"
  value       = azurerm_user_assigned_identity.user_identity.id
}
