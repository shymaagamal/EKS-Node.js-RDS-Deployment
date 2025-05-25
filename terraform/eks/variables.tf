variable "eks_cluster_subnets_ids" {
  type        = list(string)
  description = "All subnets (private + public) for EKS control plane"
}



variable "eks_node_group_subnets_ids" {
  type        = list(string)
  description = "Private subnets for EKS worker nodes"
}
# variable "eks_sg_group_nodes_id" {
#   type = string
#   description = "this is sg for group nodes"
# }
