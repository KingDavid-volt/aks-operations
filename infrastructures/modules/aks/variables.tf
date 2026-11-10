variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "The Azure region for the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.29"
}

variable "sku_tier" {
  description = "The SKU tier for the AKS cluster"
  type        = string
}

variable "service_cidr" {
  description = "The CIDR range for Kubernetes services"
  type        = string
}

variable "dns_service_ip" {
  description = "The IP address for the Kubernetes DNS service"
  type        = string
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

variable "aks_subnet_id" {
  description = "The ID of the subnet for the AKS nodes"
  type        = string
}

# User Node Pool
variable "enable_user_node_pool" {
  description = "Enable a separate user node pool"
  type        = bool
  default     = true
}

variable "user_node_count" {
  description = "The number of nodes in the user node pool"
  type        = number
  default     = null
}

variable "user_vm_size" {
  description = "The VM size for nodes in the user node pool"
  type        = string
  default     = "Standard_D4s_v5"
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

# ACR Integration
variable "acr_id" {
  description = "The ID of the Azure Container Registry"
  type        = string
  default     = null
}

variable "enable_acr_integration" {
  description = "Create the ACR pull role assignment for the AKS kubelet identity"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the AKS cluster"
  type        = map(string)
  default     = {}
}