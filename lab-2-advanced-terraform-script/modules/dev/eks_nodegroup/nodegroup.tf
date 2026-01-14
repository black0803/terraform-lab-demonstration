resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  ami_type        = var.ami_type
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  disk_size       = var.disk_size
  labels          = var.labels
  tags            = var.tags

  dynamic "taint" {
    for_each = var.taints != null ? var.taints : {}
    content {
      key    = taint.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  update_config {
    max_unavailable            = var.update_config.max_unavailable
    max_unavailable_percentage = var.update_config.max_unavailable_percentage
    update_strategy            = var.update_config.update_strategy
  }

}