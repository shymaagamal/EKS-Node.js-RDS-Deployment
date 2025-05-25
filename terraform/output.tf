output "rds_endPOint" {
  value = module.rds.rds_endpoint
}

output "SM_EKS_role_name" {
  value = module.secret_manager.SM_EKS_role_name
}
