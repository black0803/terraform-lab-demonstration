resource "aws_instance" "bastion_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile = var.iam_role == null ? module.iam_instance_profile[0].instance_profile_name : var.iam_role
  subnet_id = var.subnet_id
  root_block_device {
    volume_size = var.root_vol.volume_size
    volume_type = var.root_vol.volume_type
    iops = var.root_vol.iops
    throughput = var.root_vol.throughput
    encrypted = var.root_vol.encrypted
    kms_key_id = var.root_vol.kms_key_id
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 1
  }
  user_data_base64 = base64encode(<<-EOF
    #!/bin/bash
    set -e

    # Update system packages
    dnf update -y
    dnf install -y curl wget unzip

    # Install jq
    dnf install -y jq

    # Install kubectl (latest version)
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/

    # Verify installations
    kubectl version --client
    jq --version
    terraform version
    EOF
  )
  vpc_security_group_ids = [module.bastion_sg.id]

  tags = var.tags
}

module "iam_instance_profile" {
  count = var.iam_role == null ? 1 : 0
  source = "../../../../modules/dev/ec2_iam_role"
  prefix = var.prefix
  policy_arns = concat([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ], var.additional_policy_arns)
  tags = var.tags
}


module "bastion_sg" {
    source = "../../../../modules/dev/security_group"
    name = "${var.prefix}-bastion-sg"
    description = "Security group for bastion host"
    vpc_id = var.vpc_id
    tags = var.tags
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