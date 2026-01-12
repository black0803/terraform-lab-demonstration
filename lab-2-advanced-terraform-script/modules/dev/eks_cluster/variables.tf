variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubeapi_version" {
  description = "Kubernetes API version for the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "vpc_config" {
  description = "VPC configuration for the EKS cluster"
  type = object({
    subnet_ids              = list(string)
    security_group_ids      = optional(list(string))
    endpoint_private_access = optional(bool)
    endpoint_public_access  = optional(bool)
    public_access_cidrs     = optional(list(string))
  })
  default = {
    subnet_ids              = []
    security_group_ids      = []
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }
}

variable "tags" {
  description = "Tags to apply to the EKS cluster"
  type        = map(string)
}