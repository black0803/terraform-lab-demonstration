resource "aws_eks_cluster" "control_plane" {
  name = var.cluster_name

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster_role.arn
  version  = var.kubeapi_version

  vpc_config {
    subnet_ids = var.vpc_config.subnet_ids
    security_group_ids = var.vpc_config.security_group_ids
    endpoint_private_access = var.vpc_config.endpoint_private_access
    endpoint_public_access  = var.vpc_config.endpoint_public_access
    public_access_cidrs     = var.vpc_config.public_access_cidrs
  }

  tags = var.tags

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.ClusterRole_AmazonEKSClusterPolicy,
  ]
}