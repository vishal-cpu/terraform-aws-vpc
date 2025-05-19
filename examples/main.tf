module "vpc" {
  source = "../"

  cidr_block = "10.0.0.0/16"
  tags = {
    Name  = "example-vpc"
    Owner = "team-aws"
  }

  availability_zones           = ["us-east-1a", "us-east-1b"]
  public_default_subnet_cidr   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidr      = ["10.0.3.0/24", "10.0.4.0/24"]
  private_db_subnet_cidr       = ["10.0.5.0/24", "10.0.6.0/24"]
  single_nat_gateway           = true
  manage_default_network_acl   = true

  # Example route configurations (uncomment if needed)
  # existing_public_routes = [
  #   {
  #     cidr_block = "192.168.1.0/24",
  #     gateway_id = "vgw-12345678"
  #   }
  # ]
}