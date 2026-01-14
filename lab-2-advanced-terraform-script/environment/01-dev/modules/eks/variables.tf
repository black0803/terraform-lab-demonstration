variable "prefix" {
  description = "Naming Scheme Prefix"
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

variable "node_groups" {
  description = "Configuration for EKS node groups"
  type = map(object({
    instance_types = list(string)
    disk_size      = number
    labels         = optional(map(string))
    ami_type       = optional(string)
    taints = optional(map(object({
      value  = string
      effect = string
    })))
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    update_config = object({
      max_unavailable            = optional(number)
      max_unavailable_percentage = optional(number)
      update_strategy            = optional(string)
    })
  }))
  default = {}
}

variable "additional_node_policy_arns" {
  description = "Additional IAM policy ARNs to attach to the node group IAM role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "create_role" {
  description = "Whether to create an IAM role for the node groups"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "vPC ID used by EKS"
  type        = string
}