# Azure Authentication Variables
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where all resources will be deployed"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default = {
    Environment = "dev/test"
    ManagedBy   = "Terraform"
    Project     = "team3project"
  }
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "aks-vnet"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_name" {
  description = "The name of the subnet for AKS nodes"
  type        = string
  default     = "aks-subnet"
}

variable "aks_subnet_address_prefixes" {
  description = "The address prefixes for the AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "sku_tier" {
  description = "The SKU tier for the AKS cluster"
  type        = string
  default     = "Free"
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
}

variable "service_cidr" {
  description = "The CIDR range for Kubernetes services"
  type        = string
  default     = "172.16.0.0/16"
}

variable "dns_service_ip" {
  description = "The IP address for the Kubernetes DNS service"
  type        = string
  default     = "172.16.0.10"
}

variable "system_node_count" {
  description = "The number of nodes in the system node pool"
  type        = number
  default     = null
}

variable "system_vm_size" {
  description = "The VM size for nodes in the system node pool"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "system_node_autoscaling" {
  description = "Enable autoscaling for the system node pool"
  type        = bool
  default     = true
}

variable "system_node_min_count" {
  description = "Minimum number of nodes in the system node pool when autoscaling is enabled"
  type        = number
  default     = 2
}

variable "system_node_max_count" {
  description = "Maximum number of nodes in the system node pool when autoscaling is enabled"
  type        = number
  default     = 5
}

variable "user_node_count" {
  description = "The number of nodes in the user node pool"
  type        = number
  default     = null
}

variable "user_vm_size" {
  description = "The VM size for nodes in the user node pool"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "user_node_autoscaling" {
  description = "Enable autoscaling for the user node pool"
  type        = bool
  default     = true
}

variable "user_node_min_count" {
  description = "Minimum number of nodes in the user node pool when autoscaling is enabled"
  type        = number
  default     = 2
}

variable "user_node_max_count" {
  description = "Maximum number of nodes in the user node pool when autoscaling is enabled"
  type        = number
  default     = 5
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.29"
}

variable "acr_name" {
  description = "The name of the Azure Container Registry (ACR) to integrate with AKS"
  type        = string
  default     = null
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry (ACR)"
  type        = string
  default     = "Basic"
}

variable "acr_admin_enabled" {
  description = "Whether to enable admin user for ACR"
  type        = bool
  default     = false
}

# --- Workload Identity Federation ---

variable "workload_identity_name" {
  description = "Name of the user-assigned managed identity used for Workload Identity Federation"
  type        = string
  default     = "aks-operations-backend-id"
}

variable "service_account_namespace" {
  description = "Kubernetes namespace of the ServiceAccount that federates with the managed identity"
  type        = string
  default     = "aks-operations"
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name that federates with the managed identity"
  type        = string
  default     = "backend-workload-identity"
}

