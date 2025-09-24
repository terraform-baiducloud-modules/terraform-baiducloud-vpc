# terraform-baiducloud-vpc

Terraform module template for creating BaiduCloud VPC resources.

> **Note**: This is a template module for BaiduCloud VPC resources. The actual resource names, attributes, and provider configuration should be verified and updated based on the official BaiduCloud Terraform provider when it becomes available.

## Features

This module creates the following BaiduCloud resources:

- **VPC** - Virtual Private Cloud
- **Subnets** - Private and public subnets
- **Internet Gateway** - For public subnet internet access
- **NAT Gateway** - For private subnet internet access
- **Route Tables** - For routing traffic
- **Security Groups** - Default security group
- **Network ACLs** - Optional network-level security

## Usage

### Complete Example

```hcl
module "vpc" {
  source = "terraform-baiducloud-modules/vpc/baiducloud"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  availability_zones = ["bj-a", "bj-b", "bj-c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  create_security_group = true
  create_network_acl = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

### Simple Example

```hcl
module "vpc" {
  source = "terraform-baiducloud-modules/vpc/baiducloud"

  name = "simple-vpc"
  cidr = "10.0.0.0/16"

  availability_zones = ["bj-a", "bj-b"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  create_security_group = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |

## Providers

> **Note**: This module is a template and does not require a specific provider configuration. When the BaiduCloud Terraform provider becomes available, the provider configuration should be updated accordingly.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpc | Controls if VPC should be created | `bool` | `true` | no |
| name | Name to be used on all the resources as identifier | `string` | `""` | no |
| description | Description of the VPC | `string` | `""` | no |
| cidr | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| availability_zones | A list of availability zones names or ids in the region | `list(string)` | `[]` | no |
| private_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| public_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| enable_nat_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `false` | no |
| nat_gateway_bandwidth | Bandwidth for NAT Gateway in Mbps | `number` | `100` | no |
| create_security_group | Controls if security group should be created | `bool` | `true` | no |
| create_network_acl | Controls if network ACL should be created | `bool` | `false` | no |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | The ARN of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_name | The name of the VPC |
| private_subnets | List of IDs of private subnets |
| private_subnet_arns | List of ARNs of private subnets |
| private_subnets_cidr_blocks | List of cidr_blocks of private subnets |
| public_subnets | List of IDs of public subnets |
| public_subnet_arns | List of ARNs of public subnets |
| public_subnets_cidr_blocks | List of cidr_blocks of public subnets |
| igw_id | The ID of the Internet Gateway |
| igw_arn | The ARN of the Internet Gateway |
| nat_ids | List of IDs of the NAT Gateways |
| nat_public_ips | List of public Elastic IPs of NAT Gateways |
| private_route_table_ids | List of IDs of private route tables |
| public_route_table_ids | List of IDs of public route tables |
| private_route_table_association_ids | List of IDs of the private route table association |
| public_route_table_association_ids | List of IDs of the public route table association |
| default_security_group_id | The ID of the security group created by default on VPC creation |
| private_network_acl_id | ID of the private network ACL |
| public_network_acl_id | ID of the public network ACL |

## Examples

- [Complete VPC](examples/complete) - VPC with NAT Gateway, security groups, and network ACLs
- [Simple VPC](examples/simple) - Basic VPC with public and private subnets

## Terraform Registry

This module is published to the Terraform Registry at:
https://registry.terraform.io/modules/terraform-baiducloud-modules/vpc/baiducloud

## Development

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 0.12.0
- [Go](https://golang.org/doc/install) >= 1.18 (for running tests)
- [pre-commit](https://pre-commit.com/) (for running hooks)

### Setup

1. Clone the repository
2. Install pre-commit hooks:
   ```bash
   pre-commit install
   ```

### Running Tests

```bash
# Run terraform validate
terraform validate

# Run terraform fmt check
terraform fmt -check -recursive

# Run tflint
tflint

# Run tfsec
tfsec .

# Run terraform-docs
terraform-docs markdown table --output-file README.md --output-mode inject .
```

### Pre-commit Hooks

This project uses pre-commit hooks to ensure code quality. The hooks include:

- **terraform_fmt** - Format Terraform files
- **terraform_validate** - Validate Terraform configuration
- **terraform_docs** - Generate documentation
- **terraform_tflint** - Lint Terraform files
- **terraform_tfsec** - Security scanning
- **trivy** - Vulnerability scanning
- **detect-secrets** - Secret detection

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run pre-commit hooks
5. Submit a pull request

### Release Process

This project uses [semantic-release](https://github.com/semantic-release/semantic-release) for automated releases. The release process is triggered by conventional commits:

- `feat:` - New features (minor version bump)
- `fix:` - Bug fixes (patch version bump)
- `perf:` - Performance improvements (patch version bump)
- `docs:` - Documentation changes (patch version bump)
- `style:` - Code style changes (patch version bump)
- `refactor:` - Code refactoring (patch version bump)
- `test:` - Test changes (patch version bump)
- `build:` - Build system changes (patch version bump)
- `ci:` - CI/CD changes (patch version bump)

## License

Apache 2 Licensed. See LICENSE for full details.
