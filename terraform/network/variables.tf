# VPC module vars
variable "network_my_vpc_cidr_var" {
  type = string
 
  description = "The cidr block of VPC."
}


# Subnets Modeule vars 
variable "network_subnets" {
  type = map(object({
    cidr_block = string
    availability_zone = string
    is_public  = bool
  }))
  description = " Map of subnet configurations (public and private)"
}


# variable "network_private_subnets_cider" {
#   type = list(string)
# }