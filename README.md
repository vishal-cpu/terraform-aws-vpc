# Terraform AWS VPC Module

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform Version](https://img.shields.io/badge/terraform-≥1.3.0-blue)](https://www.terraform.io/)
[![AWS Provider Version](https://img.shields.io/badge/AWS-≥4.0-orange)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![GitHub Release](https://img.shields.io/github/v/release/vishal-cpu/terraform-aws-vpc)](https://github.com/vishal-cpu/terraform-aws-vpc/releases)

A Terraform module to provision a **production-ready VPC** on AWS with configurable subnets, NAT gateways, routing, and network ACLs.

---

## Features
- ✅ **Multi-AZ VPC** with public/private subnets  
- ✅ **NAT Gateways** (single or multi-AZ for HA)  
- ✅ **Customizable routing** (Internet Gateway, Transit Gateway, etc.)  
- ✅ **Default Network ACLs** with managed rules  
- ✅ **Tagging support** for cost allocation and governance  

---

## Usage
```hcl
module "vpc" {
  source = "github.com/vishal-cpu/terraform-aws-vpc"

  # Required
  cidr_block = "10.0.0.0/16"
  tags = {
    Name  = "prod-vpc"
    Owner = "devops-team"
  }

  # Optional (defaults shown)
  availability_zones         = ["us-east-1a", "us-east-1b"]
  public_default_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  single_nat_gateway         = true
}
```

---

## Providers

| Name | Version |
|------|---------|
| [aws](#provider_aws) | ≥4.0 |

---

## Resources

| Name | Type |
|------|------|
| [aws_default_network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| [availability_zones](#input_availability_zones) | List of availability zones to use | `list(string)` | `[]` | no |
| [cidr_block](#input_cidr_block) | VPC CIDR block | `string` | `"0.0.0.0/0"` | no |
| [create_route_private](#input_create_route_private) | Whether to create private routes | `bool` | `true` | no |
| [create_route_public](#input_create_route_public) | Whether to create public routes | `bool` | `false` | no |
| [default_network_acl_egress](#input_default_network_acl_egress) | Egress rules for default network ACL | `list(map(string))` | See code | no |
| [default_network_acl_ingress](#input_default_network_acl_ingress) | Ingress rules for default network ACL | `list(map(string))` | See code | no |
| [manage_default_network_acl](#input_manage_default_network_acl) | Manage default network ACL | `bool` | `false` | no |
| [private_app_subnet_cidr](#input_private_app_subnet_cidr) | Private app subnet CIDRs | `list(string)` | `[]` | no |
| [private_db_subnet_cidr](#input_private_db_subnet_cidr) | Private DB subnet CIDRs | `list(string)` | `[]` | no |
| [public_default_subnet_cidr](#input_public_default_subnet_cidr) | Public subnet CIDRs | `list(string)` | `[]` | no |
| [single_nat_gateway](#input_single_nat_gateway) | Use single NAT gateway | `bool` | `false` | no |
| [tags](#input_tags) | Resource tags | `map(string)` | `{}` | no |

*For full input documentation, see [variables.tf](./variables.tf)*

---

## Outputs

| Name | Description |
|------|-------------|
| [vpc_id](#output_vpc_id) | VPC ID |
| [vpc_cidr_block](#output_vpc_cidr_block) | VPC CIDR block |
| [vpc_public_subnets](#output_vpc_public_subnets) | Public subnet IDs |
| [vpc_private_subnets_app](#output_vpc_private_subnets_app) | Private app subnet IDs |
| [vpc_private_subnets_db](#output_vpc_private_subnets_db) | Private DB subnet IDs |
| [nat_gatway_ids](#output_nat_gatway_ids) | NAT gateway IDs |

*For full output documentation, see [outputs.tf](./outputs.tf)*

---

## Requirements

- Terraform >= 1.3.0
- AWS Provider >= 4.0

---

## License

MIT License. Copyright (c) [Vishal Saini](https://github.com/vishal-cpu).