resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "${local.prefix}-terraform-state-bucket"
  tags   = local.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}