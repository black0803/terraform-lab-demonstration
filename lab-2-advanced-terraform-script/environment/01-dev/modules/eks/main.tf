module "control_plane" {
  source = "../../../../modules/dev/eks_cluster"

  cluster_name    = "${var.prefix}-eks"
  kubeapi_version = var.kubeapi_version
  vpc_config = {
    subnet_ids              = var.vpc_config.subnet_ids
    security_group_ids      = concat(var.vpc_config.security_group_ids == null ? [] : var.vpc_config.security_group_ids, [module.cluster_secondary_security_group.id])
    endpoint_private_access = var.vpc_config.endpoint_private_access
    endpoint_public_access  = var.vpc_config.endpoint_public_access
    public_access_cidrs     = var.vpc_config.public_access_cidrs
  }
  tags = var.tags
}

module "node_groups" {
  for_each = var.node_groups
  source   = "../../../../modules/dev/eks_nodegroup"

  node_group_name = each.key
  cluster_name    = module.control_plane.cluster_name
  node_role_arn   = module.node_iam_role[0].role_arn
  subnet_ids      = var.vpc_config.subnet_ids
  instance_types  = each.value.instance_types
  ami_type        = each.value.ami_type
  disk_size       = each.value.disk_size
  labels          = each.value.labels
  tags            = var.tags
  taints          = each.value.taints
  scaling_config  = each.value.scaling_config
  update_config   = each.value.update_config
}

module "node_iam_role" {
  source = "../../../../modules/dev/ec2_iam_role"
  count  = var.create_role ? 1 : 0

  prefix = "${module.control_plane.cluster_name}-node"
  policy_arns = concat([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ], var.additional_node_policy_arns)
  tags = var.tags
}

module "cluster_secondary_security_group" {
  source      = "../../../../modules/dev/security_group"
  name        = "${var.prefix}-eks-secondary-sg"
  description = "Secondary security group for EKS cluster"
  vpc_id      = var.vpc_id
  tags        = var.tags
  ingress_rules = {
    https_all = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS access inbound"
    }
  }
  egress_rules = {
    outbound_all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }
}