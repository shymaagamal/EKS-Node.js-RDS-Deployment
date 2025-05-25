# resource "aws_launch_template" "eks_group_nodes" {
#   name_prefix   = "eks-nodes-"
#   image_id      = data.aws_ami.eks_ami.id 
#   instance_type = "t3.medium"

#   network_interfaces {
#     security_groups = [
#       var.eks_sg_group_nodes_id
#     ]
#   }
#     block_device_mappings {
#     device_name = "/dev/sdf"

#     ebs {
#       volume_size = 20
#     }
#   }
#     tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "eks-node"
#       "kubernetes.io/cluster/${aws_eks_cluster.eks_my_cluster.name}"="owned"
#     }
#   }
#   tag_specifications {
#   resource_type = "volume"
#   tags = {
#     Name = "eks-node-volume"
#     "kubernetes.io/cluster/${aws_eks_cluster.eks_my_cluster.name}" = "owned"
#   }
# }
# #  Bootstrap the node to join EKS
#   user_data = base64encode(<<EOF
# #!/bin/bash
# /etc/eks/bootstrap.sh ${aws_eks_cluster.eks_my_cluster.name} --kubelet-extra-args '--node-labels=type=worker'
# EOF
#   )

# }