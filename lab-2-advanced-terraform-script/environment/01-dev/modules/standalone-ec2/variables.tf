variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t4g.small"
}

variable "iam_role" {
  description = "IAM instance profile name. If null, a new one will be created"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "root_vol" {
  description = "Root volume configuration for the EC2 instance"
  type = object({
    volume_size = number
    volume_type = string
    iops        = optional(number)
    throughput  = optional(number)
    encrypted   = bool
    kms_key_id  = optional(string)
  })
  default = {
    volume_size = 30
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
    encrypted   = true
    kms_key_id  = null
  }
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "additional_policy_arns" {
  description = "Additional IAM policy ARNs to attach to the instance profile"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "vPC ID used by EKS"
  type        = string
}