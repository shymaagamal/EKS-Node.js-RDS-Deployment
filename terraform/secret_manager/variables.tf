
variable "SM_rds_credentials" {
  description = "A map containing username and password to store in Secrets Manager"
  sensitive = true

  type = map(string)
}