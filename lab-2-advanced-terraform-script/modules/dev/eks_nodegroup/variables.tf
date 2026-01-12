variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the node group"
  type        = string
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for the node group"
  type        = list(string)
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t4g.small"]
}

variable "disk_size" {
  description = "Disk size in GB for worker nodes"
  type        = number
  default     = 30
}

variable "labels" {
  description = "Map of Kubernetes labels to apply to nodes"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Map of tags to apply to the node group"
  type        = map(string)
  default     = {}
}

variable "taints" {
  description = "Map of Kubernetes taints to apply to nodes"
  type = map(object({
    value  = string
    effect = string
  }))
  default = {}
}

variable "scaling_config" {
  description = "Scaling configuration for the node group"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
  default = {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
}

variable "update_config" {
  description = "Update configuration for the node group"
  type = object({
    max_unavailable            = optional(number)
    max_unavailable_percentage = optional(number)
    update_strategy            = optional(string)
  })
  default = {
    max_unavailable            = 1
    max_unavailable_percentage = null
    update_strategy            = null
  }
}