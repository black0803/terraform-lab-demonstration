variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "chart_version" {
  description = "Version of the AWS Load Balancer Controller Helm chart"
  type        = string
  default     = "2.7.2"
}