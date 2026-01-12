locals {
  prefix = "${var.env}-${var.name}"
  tags = {
    Environment = var.env
    Owner       = var.name
  }
}