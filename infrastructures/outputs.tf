output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.name
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.networking.vnet_name
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "kube_config" {
  description = "Kubernetes configuration for the cluster (sensitive)"
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "aks_host" {
  description = "The host URL for the AKS cluster"
  value       = module.aks.host
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "The AKS cluster's OIDC issuer URL"
  value       = module.aks.oidc_issuer_url
}

output "workload_identity_client_id" {
  description = "Client ID of the workload identity -- put this in the ServiceAccount annotation"
  value       = module.workload_identity.client_id
}

output "acr_login_server" {
  description = "Login server for the Azure Container Registry"
  value       = module.acr.acr_login_server
}
