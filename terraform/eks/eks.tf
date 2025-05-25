resource "aws_eks_cluster" "eks_my_cluster" {
  name = "eks_my_cluster"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = var.eks_cluster_subnets_ids
  }


  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
  ]
}