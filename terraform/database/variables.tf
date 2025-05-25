variable "rds_subnet_groups_ids" {
  type = list(string)
  description = "these are subnets group ids "
}

variable "rds_sg" {
  type = string
  description = "sg of rds"
}

variable "rds_password_credentials" {
  description = " password of rds"
  sensitive = true

  type = string
}
variable "rds_username_credentials" {
  description = " username of rds"
  type = string
}