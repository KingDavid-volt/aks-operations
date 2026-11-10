variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region for the networking resources"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "The name of the subnet for AKS nodes"
  type        = string
}

variable "aks_subnet_address_prefixes" {
  description = "The address prefixes for the AKS subnet"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to networking resources"
  type        = map(string)
  default     = {}
}