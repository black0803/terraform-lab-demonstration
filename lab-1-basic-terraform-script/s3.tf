resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "${local.prefix}-bucket"
  tags = local.tags
}

