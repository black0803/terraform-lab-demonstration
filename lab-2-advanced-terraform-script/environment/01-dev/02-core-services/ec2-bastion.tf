module "ec2_bastion" {
  source = "../modules/standalone-ec2"
  ami_id = "ami-03edd86bd8480ac2e"
  instance_type = "t4g.small"
  subnet_id = var.bastion_subnet
  root_vol = {
    volume_size = 30
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
    encrypted   = true
    kms_key_id  = null
  }
  prefix = local.prefix
  vpc_id = data.aws_vpc.vpc.id
  tags   = merge(local.tags, {Name = "${local.prefix}-bastion"})
}