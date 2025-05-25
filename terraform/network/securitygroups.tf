resource "aws_security_group" "network_SG_for_rds" {
  name        = "rds_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.network_my_vpc.id

  tags = {
    Name = "rds_security_group"
  }
}
resource "aws_vpc_security_group_ingress_rule" "rds_ingress_from_eks_1" {
  security_group_id = aws_security_group.network_SG_for_rds.id
  cidr_ipv4 = "10.0.1.0/24"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_ingress_rule" "rds_ingress_from_eks_2" {
  security_group_id = aws_security_group.network_SG_for_rds.id
  cidr_ipv4        = "10.0.2.0/24"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_ingress_rule" "rds_ingress_from_eks_3" {
  security_group_id = aws_security_group.network_SG_for_rds.id
  cidr_ipv4        = "10.0.3.0/24"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}
resource "aws_vpc_security_group_egress_rule" "rds_egress_all_traffic_ipv4" {
  security_group_id = aws_security_group.network_SG_for_rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

# ------------------------------------------------------------------------
#               SG for EKS
#------------------------------------------------------------------------- 

# resource "aws_security_group" "network_SG_for_eks" {
#   name        = "eks_security_group"
#   description = "Allow HTTP from ALB inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.network_my_vpc.id
#   tags = {
#     Name = "eks_security_group"
#   }
# }
# resource "aws_vpc_security_group_ingress_rule" "eks_ingress_from_lb" {
#   security_group_id = aws_security_group.network_SG_for_eks.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }
# resource "aws_vpc_security_group_ingress_rule" "eks_ingress_from_self" {
#   security_group_id              = aws_security_group.network_SG_for_eks.id
#   referenced_security_group_id  = aws_security_group.network_SG_for_eks.id
#   ip_protocol                    = "-1"
# }
# resource "aws_vpc_security_group_egress_rule" "eks_egress_all_traffic_ipv4" {
#   security_group_id = aws_security_group.network_SG_for_eks.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" 
# }
