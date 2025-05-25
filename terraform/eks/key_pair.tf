resource "tls_private_key" "EC2_generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-generated-key"
  public_key = tls_private_key.EC2_generated_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  filename = "./my_key.pem"
  content  = tls_private_key.EC2_generated_key.private_key_pem
  file_permission = "0400"
}