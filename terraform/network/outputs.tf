output "networkOUT_vpc_id" {
  value = aws_vpc.network_my_vpc.id
  description = "The id of VPC"
}

output "networkOUT_subnets_id" {
   description = "Map of subnet names to their IDs"
  value       = {for key , subnet in aws_subnet.network_subnets :
          key=>subnet.id
  }
}
output "networkOUT_SG_for_rds_id" {
  value = aws_security_group.network_SG_for_rds.id
  description = "id of sg for rds"
}
# output "networkOUT_SG_for_eks_nodes_id" {
#   value = aws_security_group.network_SG_for_eks.id
#   description = "id of sg for eks"
# }
