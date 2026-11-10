# Azure Authentication (required)
subscription_id = "bb10971c-118c-4506-b0bf-76d802945f9f" # "Xxxx-xxxx-xxx-xxx-xxx-xxxxx"
tenant_id       = "0b60fed4-5fc9-409d-95f2-271114f4c86f" # "Xxxx-xxxx-xxx-xxx-xxx-xxxxx"

# Resource Configuration
resource_group_name = "OperationsTeam3RG"
location            = "West Europe"
cluster_name        = "team3cluster"
dns_prefix          = "team3dns"
kubernetes_version  = "1.35.6"
sku_tier            = "Free"
service_cidr        = "172.16.0.0/16"
dns_service_ip      = "172.16.0.10"

# System Node Pool
system_node_count       = 2
system_vm_size          = "Standard_D2s_v5"
system_node_autoscaling = true
system_node_min_count   = 2
system_node_max_count   = 5

# User Node Pool
user_node_count       = 3
user_vm_size          = "Standard_D2s_v5"
user_node_autoscaling = true
user_node_min_count   = 1
user_node_max_count   = 5

# ACR Configuration
acr_name          = "team3acr" # Will use ${cluster_name}acr if not specified
acr_sku           = "Basic"
acr_admin_enabled = false

# Networking
vnet_name                   = "aks-vnet"
vnet_address_space          = ["10.0.0.0/16"]
aks_subnet_name             = "aks-subnet"
aks_subnet_address_prefixes = ["10.0.1.0/24"]

# Tags
tags = {
  Environment = "dev/test"
  ManagedBy   = "Terraform"
  Project     = "team3project"
}

# --- Workload Identity Federation ---
workload_identity_name   = "aks-operations-backend-id"
service_account_namespace = "aks-operations"
service_account_name      = "backend-workload-identity"
