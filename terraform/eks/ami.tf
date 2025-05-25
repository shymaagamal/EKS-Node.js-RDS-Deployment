data "aws_ami" "eks_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.31-v*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["602401143452"] # Amazon EKS AMI account ID
}
