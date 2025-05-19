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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ≥4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_default_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_nat"></a> [availability\_nat](#input\_availability\_nat) | n/a | `list(any)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | n/a | `list(any)` | `[]` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | List of CIDR ranges . Defaults to 0.0.0.0/0 | `string` | `"0.0.0.0/0"` | no |
| <a name="input_create_route_private"></a> [create\_route\_private](#input\_create\_route\_private) | Whether to create routes and integrations resources | `bool` | `true` | no |
| <a name="input_create_route_public"></a> [create\_route\_public](#input\_create\_route\_public) | Whether to create routes and integrations resources | `bool` | `false` | no |
| <a name="input_default_network_acl_egress"></a> [default\_network\_acl\_egress](#input\_default\_network\_acl\_egress) | List of maps of egress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br/>  {<br/>    "action": "allow",<br/>    "cidr_block": "0.0.0.0/0",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "rule_no": 100,<br/>    "to_port": 0<br/>  },<br/>  {<br/>    "action": "allow",<br/>    "from_port": 0,<br/>    "ipv6_cidr_block": "::/0",<br/>    "protocol": "-1",<br/>    "rule_no": 101,<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_default_network_acl_ingress"></a> [default\_network\_acl\_ingress](#input\_default\_network\_acl\_ingress) | List of maps of ingress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br/>  {<br/>    "action": "allow",<br/>    "cidr_block": "0.0.0.0/0",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "rule_no": 100,<br/>    "to_port": 0<br/>  },<br/>  {<br/>    "action": "allow",<br/>    "from_port": 0,<br/>    "ipv6_cidr_block": "::/0",<br/>    "protocol": "-1",<br/>    "rule_no": 101,<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_default_network_acl_name"></a> [default\_network\_acl\_name](#input\_default\_network\_acl\_name) | Name to be used on the Default Network ACL | `string` | `""` | no |
| <a name="input_existing_private_routes"></a> [existing\_private\_routes](#input\_existing\_private\_routes) | List of existing routes to preserve in private route tables | <pre>list(object({<br/>    cidr_block = string<br/>    gateway_id = string<br/>  }))</pre> | `null` | no |
| <a name="input_existing_public_routes"></a> [existing\_public\_routes](#input\_existing\_public\_routes) | List of existing routes to preserve in public route tables | <pre>list(object({<br/>    cidr_block = string<br/>    gateway_id = string<br/>  }))</pre> | `null` | no |
| <a name="input_external_route_private"></a> [external\_route\_private](#input\_external\_route\_private) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_external_route_public"></a> [external\_route\_public](#input\_external\_route\_public) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_manage_default_network_acl"></a> [manage\_default\_network\_acl](#input\_manage\_default\_network\_acl) | Should be true to adopt and manage Default Network ACL | `bool` | `false` | no |
| <a name="input_private_app_subnet_cidr"></a> [private\_app\_subnet\_cidr](#input\_private\_app\_subnet\_cidr) | n/a | `list(any)` | `[]` | no |
| <a name="input_private_db_subnet_cidr"></a> [private\_db\_subnet\_cidr](#input\_private\_db\_subnet\_cidr) | n/a | `list(any)` | `[]` | no |
| <a name="input_propagate_private_route_tables_vgw"></a> [propagate\_private\_route\_tables\_vgw](#input\_propagate\_private\_route\_tables\_vgw) | Whether to create routes and integrations resources | `list(string)` | `[]` | no |
| <a name="input_public_default_subnet_cidr"></a> [public\_default\_subnet\_cidr](#input\_public\_default\_subnet\_cidr) | n/a | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | variable "cidr\_block" {} | `any` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_tgw_cidr"></a> [tgw\_cidr](#input\_tgw\_cidr) | List of CIDR ranges . Defaults to 0.0.0.0/0 | `string` | `"0.0.0.0/0"` | no |
| <a name="input_tgw_id"></a> [tgw\_id](#input\_tgw\_id) | List of CIDR ranges . Defaults to 0.0.0.0/0 | `string` | `null` | no |
| <a name="input_tgw_pub_cidr"></a> [tgw\_pub\_cidr](#input\_tgw\_pub\_cidr) | List of CIDR ranges . Defaults to 0.0.0.0/0 | `string` | `"0.0.0.0/0"` | no |
| <a name="input_tgw_pub_id"></a> [tgw\_pub\_id](#input\_tgw\_pub\_id) | List of CIDR ranges . Defaults to 0.0.0.0/0 | `string` | `null` | no |
| <a name="input_tgw_pub_route"></a> [tgw\_pub\_route](#input\_tgw\_pub\_route) | Name of the document | `bool` | `false` | no |
| <a name="input_tgw_route"></a> [tgw\_route](#input\_tgw\_route) | Name of the document | `bool` | `false` | no |
| <a name="input_vpn_gateway_id"></a> [vpn\_gateway\_id](#input\_vpn\_gateway\_id) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_subnets"></a> [all\_subnets](#output\_all\_subnets) | n/a |
| <a name="output_nat_gatway_ids"></a> [nat\_gatway\_ids](#output\_nat\_gatway\_ids) | n/a |
| <a name="output_route_tables_private_app"></a> [route\_tables\_private\_app](#output\_route\_tables\_private\_app) | n/a |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vpc_private_subnets_app"></a> [vpc\_private\_subnets\_app](#output\_vpc\_private\_subnets\_app) | n/a |
| <a name="output_vpc_private_subnets_db"></a> [vpc\_private\_subnets\_db](#output\_vpc\_private\_subnets\_db) | n/a |
| <a name="output_vpc_public_subnets"></a> [vpc\_public\_subnets](#output\_vpc\_public\_subnets) | n/a |
