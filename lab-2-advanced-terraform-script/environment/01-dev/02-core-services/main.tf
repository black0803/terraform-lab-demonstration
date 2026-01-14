terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # optional (will choose latest of major version 6 with ~> operator)
    }
  }
  required_version = "~> 1.10.0" # optional
  backend "s3" {
    bucket       = "lab-nobel-terraform-state-bucket"
    key          = "state/dev/02-core-services.tfstate"
    region       = "ap-southeast-3"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-southeast-3"
}
