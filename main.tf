# BaiduCloud VPC Module Template
# 
# This is a template module for creating VPC resources in BaiduCloud.
# The actual resource names, attributes, and provider configuration
# should be verified and updated based on the official BaiduCloud Terraform provider.
#
# This module provides a reference implementation that can be adapted
# when the BaiduCloud Terraform provider becomes available.

# VPC
# Note: Resource name and attributes should be verified against BaiduCloud provider docs
resource "baiducloud_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  name        = var.name
  description = var.description
  cidr        = var.cidr
  tags        = var.tags
}

# Private Subnets
# Note: Subnet resource configuration should be verified
resource "baiducloud_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id      = baiducloud_vpc.this[0].id
  name        = "${var.name}-private-${count.index + 1}"
  cidr        = var.private_subnets[count.index]
  zone_name   = var.availability_zones[count.index]
  description = "Private subnet ${count.index + 1}"
  tags        = var.tags
}

# Public Subnets
resource "baiducloud_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id      = baiducloud_vpc.this[0].id
  name        = "${var.name}-public-${count.index + 1}"
  cidr        = var.public_subnets[count.index]
  zone_name   = var.availability_zones[count.index]
  description = "Public subnet ${count.index + 1}"
  tags        = var.tags
}

# Internet Gateway
resource "baiducloud_internet_gateway" "this" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id      = baiducloud_vpc.this[0].id
  name        = "${var.name}-igw"
  description = "Internet Gateway"
  tags        = var.tags
}

# NAT Gateway (if enabled)
resource "baiducloud_eip" "nat" {
  count = var.create_vpc && var.enable_nat_gateway && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  bandwidth_in_mbps = var.nat_gateway_bandwidth
  tags              = var.tags
}

resource "baiducloud_nat_gateway" "this" {
  count = var.create_vpc && var.enable_nat_gateway && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  name        = "${var.name}-nat-${count.index + 1}"
  vpc_id      = baiducloud_vpc.this[0].id
  subnet_id   = baiducloud_subnet.public[count.index].id
  eip_id      = baiducloud_eip.nat[count.index].id
  description = "NAT Gateway ${count.index + 1}"
  tags        = var.tags
}

# Route Tables
resource "baiducloud_route_table" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? 1 : 0

  vpc_id      = baiducloud_vpc.this[0].id
  name        = "${var.name}-private"
  description = "Private route table"
  tags        = var.tags
}

resource "baiducloud_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id      = baiducloud_vpc.this[0].id
  name        = "${var.name}-public"
  description = "Public route table"
  tags        = var.tags
}

# Routes
resource "baiducloud_route" "private_nat" {
  count = var.create_vpc && var.enable_nat_gateway && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  route_table_id         = baiducloud_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = baiducloud_nat_gateway.this[count.index].id
}

resource "baiducloud_route" "public_internet" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = baiducloud_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = baiducloud_internet_gateway.this[0].id
}

# Route Table Associations
resource "baiducloud_route_table_association" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = baiducloud_subnet.private[count.index].id
  route_table_id = baiducloud_route_table.private[0].id
}

resource "baiducloud_route_table_association" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = baiducloud_subnet.public[count.index].id
  route_table_id = baiducloud_route_table.public[0].id
}

# Security Groups
resource "baiducloud_security_group" "default" {
  count = var.create_vpc && var.create_security_group ? 1 : 0

  vpc_id      = baiducloud_vpc.this[0].id
  name        = "${var.name}-default"
  description = "Default security group for ${var.name} VPC"
  tags        = var.tags
}

resource "baiducloud_security_group_rule" "default_egress" {
  count = var.create_vpc && var.create_security_group ? 1 : 0

  security_group_id = baiducloud_security_group.default[0].id
  direction         = "egress"
  protocol          = "all"
  port_range        = "1-65535"
  source_ip         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"
}