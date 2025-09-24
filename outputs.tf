# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(baiducloud_vpc.this[0].id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(baiducloud_vpc.this[0].arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(baiducloud_vpc.this[0].cidr, null)
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = try(baiducloud_vpc.this[0].name, null)
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = baiducloud_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = baiducloud_subnet.private[*].arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = baiducloud_subnet.private[*].cidr
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = baiducloud_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = baiducloud_subnet.public[*].arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = baiducloud_subnet.public[*].cidr
}

# Internet Gateway
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = try(baiducloud_internet_gateway.this[0].id, null)
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(baiducloud_internet_gateway.this[0].arn, null)
}

# NAT Gateway
output "nat_ids" {
  description = "List of IDs of the NAT Gateways"
  value       = baiducloud_nat_gateway.this[*].id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs of NAT Gateways"
  value       = baiducloud_eip.nat[*].public_ip
}

# Route Tables
output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = baiducloud_route_table.private[*].id
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = baiducloud_route_table.public[*].id
}

# Route Table Associations
output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = baiducloud_route_table_association.private[*].id
}

output "public_route_table_association_ids" {
  description = "List of IDs of the public route table association"
  value       = baiducloud_route_table_association.public[*].id
}

# Security Groups
output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(baiducloud_security_group.default[0].id, null)
}

# Network ACLs
output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = try(baiducloud_network_acl.private[0].id, null)
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = try(baiducloud_network_acl.public[0].id, null)
}
