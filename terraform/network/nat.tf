resource "aws_nat_gateway" "network_nat_gatway" {
  allocation_id = aws_eip.network_eIP.id
  subnet_id = element([
    for subnet_key, subnet in aws_subnet.network_subnets : subnet.id
    if var.network_subnets[subnet_key].is_public
  ], 0)
  depends_on = [aws_internet_gateway.network_gateway]
}