resource "aws_subnet" "network_subnets" {
  vpc_id     = aws_vpc.network_my_vpc.id
  for_each = var.network_subnets
  cidr_block = each.value.cidr_block
  availability_zone= each.value.availability_zone
  map_public_ip_on_launch = each.value.is_public
  tags = merge( 
    {
      Name = each.key
      "kubernetes.io/cluster/eks_my_cluster"="owned"

    },
    each.value.is_public ? {"kubernetes.io/role/elb" = "1" } : {"kubernetes.io/role/internal-elb" = "1"}
  )
 
}





