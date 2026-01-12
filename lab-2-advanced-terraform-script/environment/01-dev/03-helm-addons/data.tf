data "aws_eks_cluster" "cluster" {
  name = "${var.env}-${var.name}-eks"
}