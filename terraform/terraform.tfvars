my_vpc_cidr_var = "10.0.0.0/16"
my_subnets = {
private-1 = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    is_public         = false
  }
 private-2 = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    is_public         = false
  }
  private-3 = {
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1c"
    is_public         = false
  }
  public-1 = {
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1a"
    is_public         = true
  }
  public-2 = {
    cidr_block        = "10.0.5.0/24"
    availability_zone = "us-east-1b"
    is_public         = true
  }
  public-3 = {
    cidr_block        = "10.0.6.0/24"
    availability_zone = "us-east-1c"
    is_public         = true
  }

}
