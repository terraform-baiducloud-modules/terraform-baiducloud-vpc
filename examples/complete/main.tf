# Complete VPC Example
# This example shows how to use the BaiduCloud VPC module
# Note: This is a template example - actual usage requires BaiduCloud provider

module "vpc" {
  source = "../../"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  availability_zones = ["bj-a", "bj-b", "bj-c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway    = true
  create_security_group = true
  create_network_acl    = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}