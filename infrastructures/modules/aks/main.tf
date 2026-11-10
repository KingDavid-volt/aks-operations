resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  oidc_issuer_enabled      = true
  workload_identity_enabled = true

  node_provisioning_profile {
    mode = "Manual"
  }

  default_node_pool {
    name           = "system"
    auto_scaling_enabled = var.system_node_autoscaling
    min_count           = var.system_node_min_count
    max_count           = var.system_node_max_count
    node_count          = var.system_node_autoscaling ? var.system_node_min_count : var.system_node_count
    vm_size             = var.system_vm_size
    vnet_subnet_id      = var.aks_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  tags = var.tags
}

# Add User Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.user_vm_size
  vnet_subnet_id        = var.aks_subnet_id

  auto_scaling_enabled = var.user_node_autoscaling
  min_count           = var.user_node_min_count
  max_count           = var.user_node_max_count
  node_count          = var.user_node_autoscaling ? null : var.user_node_count
}

# Role assignment for AKS to pull from ACR
# This is optional because some Azure principals lack permission to create role assignments.
resource "azurerm_role_assignment" "aks_acr_pull" {
  count = var.enable_acr_integration ? 1 : 0

  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}
