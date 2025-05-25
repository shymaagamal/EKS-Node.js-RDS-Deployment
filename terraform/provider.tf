provider "aws" {
  region = "us-east-1"
  profile = "default"
}

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}


data "aws_eks_cluster" "eks_my_cluster" {
  name = "eks_my_cluster"  
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = data.aws_eks_cluster.eks_my_cluster.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_my_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_my_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token

}