resource "aws_eip" "network_eIP" {

  tags = {
    Name = "EIP for NAT Gateway"
  }
}
