resource "aws_vpc" "network_my_vpc" {
  cidr_block       = var.network_my_vpc_cidr_var
  enable_dns_hostnames = true
  enable_dns_support=true
  tags = {
    Name = "my-vpc"
    "kubernetes.io/cluster/eks_my_cluster"="owned"
  }
}