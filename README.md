# Terraform AWS VPC Module ![Terraform Version](https://img.shields.io/badge/terraform-≥1.3.0-blue) ![AWS Provider](https://img.shields.io/badge/AWS-≥4.0-orange) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A production-grade Terraform module to deploy **multi-tier VPC architectures** on AWS with configurable subnets, NAT gateways, routing, and security controls.

## Features

- **Multi-AZ Networking**: Public/private subnets across availability zones
- **Flexible NAT Strategies**: Single or multi-AZ NAT gateways for cost/HA tradeoffs
- **Advanced Routing**: Support for Internet Gateway, Transit Gateway, and custom routes
- **Security Controls**: Managed default NACLs with customizable rules
- **Tagging Framework**: Consistent tagging for cost tracking and governance

## Architecture

![AWS VPC Architecture](https://raw.githubusercontent.com/vishal-cpu/terraform-aws-vpc/main/docs/vpc-architecture-diagram.png)

**Key Components:**
1. **Public Subnets** (IGW attached) - For load balancers/bastions
2. **Private App Subnets** (NAT Gateway) - Application workloads
3. **Private DB Subnets** (No Internet) - Databases/caches
4. **Multi-AZ Deployment** - High availability
5. **Centralized NAT** - Cost optimization

```hcl
module "vpc" {
  source = "github.com/vishal-cpu/terraform-aws-vpc"
  region = "us-east-1"

  cidr_block = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  public_default_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidr    = ["10.0.3.0/24", "10.0.4.0/24"]
  private_db_subnet_cidr     = ["10.0.5.0/24", "10.0.6.0/24"]

  single_nat_gateway = true # Cost optimization
  tags = {
    Environment = "prod"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cidr_block` | VPC primary CIDR block | `string` | - | ✓ |
| `availability_zones` | AZs for subnet placement | `list(string)` | `[]` | no |
| `public_default_subnet_cidr` | Public subnet CIDRs | `list(string)` | `[]` | no |
| `single_nat_gateway` | Use shared NAT gateway | `bool` | `false` | no |

**Full Reference:** [variables.tf](./variables.tf)

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | Created VPC ID |
| `private_app_subnet_ids` | Application-tier subnet IDs |
| `nat_gateway_ips` | NAT gateway public IPs |

**All Outputs:** [outputs.tf](./outputs.tf)

## Requirements

- Terraform ≥1.3.0
- AWS Provider ≥4.0

## Contributing  
PRs welcome! See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## License  
MIT License. Copyright (c) [Vishal Saini](https://github.com/vishal-cpu).