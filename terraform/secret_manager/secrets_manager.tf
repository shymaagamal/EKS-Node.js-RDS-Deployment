resource "aws_secretsmanager_secret" "SM_for_rds" {
  name = "my_SM_for_rds_eks"
}


resource "aws_secretsmanager_secret_version" "SM_for_rds_version" {
  secret_id     = aws_secretsmanager_secret.SM_for_rds.id
  secret_string = jsonencode(var.SM_rds_credentials)
}