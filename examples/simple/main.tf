# Simple VPC Example
# This example shows a basic VPC configuration
# Note: This is a template example - actual usage requires BaiduCloud provider

module "vpc" {
  source = "../../"

  name = "simple-vpc"
  cidr = "10.0.0.0/16"

  availability_zones = ["bj-a", "bj-b"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway    = false
  create_security_group = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}