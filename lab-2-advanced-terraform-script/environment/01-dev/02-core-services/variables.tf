variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "name" {
  description = "Project or resource name"
  type        = string
}

variable "bastion_subnet" {
  description = "Subnet ID where the bastion EC2 instance will be launched"
  type        = string
}