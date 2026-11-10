variable "name" {
  description = "Name of the user-assigned managed identity"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to create the identity in"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "oidc_issuer_url" {
  description = "The AKS cluster's OIDC issuer URL (from the aks module output)"
  type        = string
}

variable "service_account_namespace" {
  description = "Kubernetes namespace the ServiceAccount lives in"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name this identity federates with"
  type        = string
}

variable "role_assignments" {
  description = "Roles to grant this identity, as a map of arbitrary key => { role_definition_name, scope }"
  type = map(object({
    role_definition_name = string
    scope                 = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to the identity"
  type        = map(string)
  default     = {}
}
