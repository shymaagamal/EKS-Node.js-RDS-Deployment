resource "aws_route_table_association" "network_subnet_association" {
  for_each = var.network_subnets
  subnet_id =aws_subnet.network_subnets[each.key].id
  route_table_id = each.value.is_public ? aws_route_table.network_public_routetable.id  : aws_route_table.network_private_routetable.id 
}

