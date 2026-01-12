module "aws_load_balancer_controller" {
  source = "../modules/addon/aws_lb_controller"
  cluster_name = data.aws_eks_cluster.cluster.name
}