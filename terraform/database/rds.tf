resource "aws_db_instance" "rds" {
  allocated_storage    = 5
  db_name              = "myrds"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  vpc_security_group_ids = [var.rds_sg]
  username             = var.rds_username_credentials
  password             = var.rds_password_credentials
   db_subnet_group_name=aws_db_subnet_group.rds_subnet_group.name
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}