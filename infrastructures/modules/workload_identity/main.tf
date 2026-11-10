# User-assigned managed identity that the backend Pod (or a GitHub Actions
# job) authenticates as, via OIDC federation — no client secret involved.
resource "azurerm_user_assigned_identity" "user_identity" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Links the identity to a specific Kubernetes ServiceAccount in a specific
# namespace. Any pod running as that ServiceAccount (with the
# azure.workload.identity/use: "true" label set) can request an Azure AD
# token as this identity — that's the whole passwordless mechanism.
resource "azurerm_federated_identity_credential" "aks_service_account" {
  name                = "${var.name}-fic"
  user_assigned_identity_id = azurerm_user_assigned_identity.user_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
}

# Optional least-privilege role grants (e.g. AcrPull, Monitoring Reader).
# Pass an empty map if you'd rather assign roles manually / per-environment.
resource "azurerm_role_assignment" "grants" {
  for_each = var.role_assignments

  principal_id                    = azurerm_user_assigned_identity.user_identity.principal_id
  role_definition_name            = each.value.role_definition_name
  scope                           = each.value.scope
  skip_service_principal_aad_check = true
}
