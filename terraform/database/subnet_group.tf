resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = var.rds_subnet_groups_ids

  tags = {
    Name = "rds subnet group"
  }
}