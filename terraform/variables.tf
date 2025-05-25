variable "my_vpc_cidr_var" {
  type = string
 
  description = "The cidr block of VPC."
}


# Subnets Modeule vars 
variable "my_subnets" {
  type = map(object({
    cidr_block = string
    availability_zone = string
    is_public  = bool
  }))
  description = " subnet definitions with AZ and public/private flag."
}





variable "my_SM_rds_credentials" {
  description = "A map containing username and password to store in Secrets Manager"
  sensitive = true

  type = map(string)
}