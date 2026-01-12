terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "kubectl" {
#   host                   = var.kubernetes_host
#   cluster_ca_certificate = base64decode(var.kubernetes_cluster_ca_certificate)
#   token                  = var.kubernetes_token
    config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "http" {
  
}

provider "aws" {
  region = "ap-southeast-3"
}