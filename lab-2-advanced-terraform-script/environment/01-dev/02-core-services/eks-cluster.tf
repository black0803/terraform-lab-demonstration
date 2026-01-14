module "eks" {
  source          = "../modules/eks"
  prefix          = local.prefix
  kubeapi_version = "1.33"
  vpc_id          = data.aws_vpc.vpc.id
  vpc_config = {
    subnet_ids              = [for i in data.aws_subnet.private_subnet : i.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  node_groups = {
    infra = {
      instance_types = ["t4g.small", "t4g.medium"]
      disk_size      = 30
      ami_type       = "AL2023_ARM_64_STANDARD"
      labels = {
        role       = "infra"
        managed_by = "nodegroup"
      }
      # taints = {
      #   role = {
      #     value  = "infra"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
      scaling_config = {
        desired_size = 2
        max_size     = 2
        min_size     = 1
      }
      update_config = {
        max_unavailable = 1
        update_strategy = "DEFAULT"
      }
    }
  }
  tags = local.tags
}