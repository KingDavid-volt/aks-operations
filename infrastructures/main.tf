# Create the Resource Group
module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create the Networking (VNet and Subnet)
module "networking" {
  source                      = "./modules/networking"
  resource_group_name         = module.resource_group.name
  location                    = module.resource_group.location
  vnet_name                   = var.vnet_name
  vnet_address_space          = var.vnet_address_space
  aks_subnet_name             = var.aks_subnet_name
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes
  tags                        = var.tags
}

# Create ACR (Azure Container Registry)
module "acr" {
  source              = "./modules/acr"
  acr_name            = var.acr_name != null ? var.acr_name : "${var.cluster_name}acr"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
}

# Create the AKS Cluster
module "aks" {
  source              = "./modules/aks"
  cluster_name        = var.cluster_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier
  service_cidr        = var.service_cidr
  dns_service_ip      = var.dns_service_ip

  # System Node Pool
  system_node_count       = var.system_node_count
  system_vm_size          = var.system_vm_size
  system_node_autoscaling = var.system_node_autoscaling
  system_node_min_count   = var.system_node_min_count
  system_node_max_count   = var.system_node_max_count
  aks_subnet_id           = module.networking.aks_subnet_id

  # User Node Pool
  user_node_count       = var.user_node_count
  user_vm_size          = var.user_vm_size
  user_node_autoscaling = var.user_node_autoscaling
  user_node_min_count   = var.user_node_min_count
  user_node_max_count   = var.user_node_max_count

  # ACR Integration
  acr_id                 = module.acr.acr_id
  enable_acr_integration = true

  tags = var.tags
}

# Workload Identity Federation: lets the backend Pod's ServiceAccount
# authenticate to Azure (Monitor, ACR, etc.) without any stored secret.
module "workload_identity" {
  source = "./modules/workload_identity"

  name                      = var.workload_identity_name
  resource_group_name       = module.resource_group.name
  location                  = module.resource_group.location
  oidc_issuer_url           = module.aks.oidc_issuer_url
  service_account_namespace = var.service_account_namespace
  service_account_name      = var.service_account_name
  tags                      = var.tags

  role_assignments = {
    acr_pull = {
      role_definition_name = "AcrPull"
      scope                = module.acr.acr_id
    }
    monitoring_reader = {
      role_definition_name = "Monitoring Reader"
      scope                = module.resource_group.id
    }
  }

  depends_on = [module.aks]
}