terraform {
  backend "s3" {
    bucket = "shaimaa-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}