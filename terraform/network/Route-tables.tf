resource "aws_route_table" "network_private_routetable" {
  vpc_id = aws_vpc.network_my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.network_nat_gatway.id
  }



  tags = {
    Name = "private-RouteTable"
  }
}


resource "aws_route_table" "network_public_routetable" {
  vpc_id = aws_vpc.network_my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.network_gateway.id
  }



  tags = {
    Name = "public-RouteTable"
  }
}

