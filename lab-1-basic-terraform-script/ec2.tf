resource "aws_instance" "bastion_instance" {
  ami           = "ami-078462934228fde0e"
  instance_type = "t4g.small"
  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
  subnet_id = local.subnet_id
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    iops = 3000
    throughput = 125
    encrypted = true
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
    curl -LO "https://dl.k8s.io/release/$$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/

    # Install terraform (latest version)
    TERRAFORM_VERSION=$$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep -oP '"tag_name": "\K[^"]*' | sed 's/v//')
    wget https://releases.hashicorp.com/terraform/$${TERRAFORM_VERSION}/terraform_$${TERRAFORM_VERSION}_linux_arm64.zip
    unzip terraform_$${TERRAFORM_VERSION}_linux_arm64.zip
    mv terraform /usr/local/bin/
    rm terraform_$${TERRAFORM_VERSION}_linux_arm64.zip

    # Verify installations
    kubectl version --client
    jq --version
    terraform version
    EOF
)

  tags = merge(local.tags, {Name = "${local.prefix}-bastion"})
  depends_on = [ aws_iam_role_policy_attachment.bastion_role_ssm_policy_attachment ]
}

resource "aws_iam_role" "bastion_role" {
  name = "${local.prefix}-bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bastion_role_ssm_policy_attachment" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${local.prefix}-bastion-profile"
  role = aws_iam_role.bastion_role.name
}

