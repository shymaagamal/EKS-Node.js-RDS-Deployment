module "network" {
  source = "./network"
  network_my_vpc_cidr_var = var.my_vpc_cidr_var
  network_subnets = var.my_subnets
  
  # network_private_subnets_cider = []

  
}
module "eks" {
  source = "./eks"
  eks_cluster_subnets_ids = values(module.network.networkOUT_subnets_id)
  eks_node_group_subnets_ids = [ for private_subnet_key , id in module.network.networkOUT_subnets_id: 
    id if can(regex("private", private_subnet_key))    
  ]
  # eks_sg_group_nodes_id = module.network.networkOUT_SG_for_eks_nodes_id
}
module "rds" {
  source = "./database"
  rds_sg = module.network.networkOUT_SG_for_rds_id
  rds_subnet_groups_ids = [ for private_subnet_key , id in module.network.networkOUT_subnets_id: 
    id if can(regex("private", private_subnet_key))]  
  rds_password_credentials = var.my_SM_rds_credentials["password"]
  rds_username_credentials = var.my_SM_rds_credentials["username"]
}
module "secret_manager" {
  source = "./secret_manager"
  SM_rds_credentials = var.my_SM_rds_credentials

}
module "ecr" {
  source = "./ecr"

}


