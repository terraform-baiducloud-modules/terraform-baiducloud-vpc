# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [Unreleased]

### Features

* Initial release of BaiduCloud VPC Terraform module
* Support for VPC creation with configurable CIDR
* Support for private and public subnets across availability zones
* Internet Gateway for public subnet internet access
* NAT Gateway for private subnet internet access (optional)
* Route tables for private and public subnets
* Security groups with default egress rules
* Network ACLs for network-level security (optional)
* Comprehensive documentation and examples
* GitHub Actions CI/CD pipeline
* Pre-commit hooks for code quality
* Security scanning with TFSec, Trivy, and Checkov
* Automated releases with semantic versioning
