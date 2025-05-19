## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_default_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) (resource)
- [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) (resource)
- [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) (resource)
- [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) (resource)
- [aws_route_table.private_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) (resource)
- [aws_route_table.public_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) (resource)
- [aws_route_table_association.private_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) (resource)
- [aws_route_table_association.public_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) (resource)
- [aws_subnet.private_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) (resource)
- [aws_subnet.private_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) (resource)
- [aws_subnet.public_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) (resource)
- [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_region"></a> [region](#input\_region)

Description: variable "cidr\_block" {}

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_availability_nat"></a> [availability\_nat](#input\_availability\_nat)

Description: n/a

Type: `list(any)`

Default: `[]`

### <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones)

Description: n/a

Type: `list(any)`

Default: `[]`

### <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block)

Description: List of CIDR ranges . Defaults to 0.0.0.0/0

Type: `string`

Default: `"0.0.0.0/0"`

### <a name="input_create_route_private"></a> [create\_route\_private](#input\_create\_route\_private)

Description: Whether to create routes and integrations resources

Type: `bool`

Default: `true`

### <a name="input_create_route_public"></a> [create\_route\_public](#input\_create\_route\_public)

Description: Whether to create routes and integrations resources

Type: `bool`

Default: `false`

### <a name="input_default_network_acl_egress"></a> [default\_network\_acl\_egress](#input\_default\_network\_acl\_egress)

Description: List of maps of egress rules to set on the Default Network ACL

Type: `list(map(string))`

Default:

```json
[
  {
    "action": "allow",
    "cidr_block": "0.0.0.0/0",
    "from_port": 0,
    "protocol": "-1",
    "rule_no": 100,
    "to_port": 0
  },
  {
    "action": "allow",
    "from_port": 0,
    "ipv6_cidr_block": "::/0",
    "protocol": "-1",
    "rule_no": 101,
    "to_port": 0
  }
]
```

### <a name="input_default_network_acl_ingress"></a> [default\_network\_acl\_ingress](#input\_default\_network\_acl\_ingress)

Description: List of maps of ingress rules to set on the Default Network ACL

Type: `list(map(string))`

Default:

```json
[
  {
    "action": "allow",
    "cidr_block": "0.0.0.0/0",
    "from_port": 0,
    "protocol": "-1",
    "rule_no": 100,
    "to_port": 0
  },
  {
    "action": "allow",
    "from_port": 0,
    "ipv6_cidr_block": "::/0",
    "protocol": "-1",
    "rule_no": 101,
    "to_port": 0
  }
]
```

### <a name="input_default_network_acl_name"></a> [default\_network\_acl\_name](#input\_default\_network\_acl\_name)

Description: Name to be used on the Default Network ACL

Type: `string`

Default: `""`

### <a name="input_existing_private_routes"></a> [existing\_private\_routes](#input\_existing\_private\_routes)

Description: List of existing routes to preserve in private route tables

Type:

```hcl
list(object({
    cidr_block = string
    gateway_id = string
  }))
```

Default: `null`

### <a name="input_existing_public_routes"></a> [existing\_public\_routes](#input\_existing\_public\_routes)

Description: List of existing routes to preserve in public route tables

Type:

```hcl
list(object({
    cidr_block = string
    gateway_id = string
  }))
```

Default: `null`

### <a name="input_external_route_private"></a> [external\_route\_private](#input\_external\_route\_private)

Description: n/a

Type: `list(map(string))`

Default: `[]`

### <a name="input_external_route_public"></a> [external\_route\_public](#input\_external\_route\_public)

Description: n/a

Type: `list(map(string))`

Default: `[]`

### <a name="input_manage_default_network_acl"></a> [manage\_default\_network\_acl](#input\_manage\_default\_network\_acl)

Description: Should be true to adopt and manage Default Network ACL

Type: `bool`

Default: `false`

### <a name="input_private_app_subnet_cidr"></a> [private\_app\_subnet\_cidr](#input\_private\_app\_subnet\_cidr)

Description: n/a

Type: `list(any)`

Default: `[]`

### <a name="input_private_db_subnet_cidr"></a> [private\_db\_subnet\_cidr](#input\_private\_db\_subnet\_cidr)

Description: n/a

Type: `list(any)`

Default: `[]`

### <a name="input_propagate_private_route_tables_vgw"></a> [propagate\_private\_route\_tables\_vgw](#input\_propagate\_private\_route\_tables\_vgw)

Description: Whether to create routes and integrations resources

Type: `list(string)`

Default: `[]`

### <a name="input_public_default_subnet_cidr"></a> [public\_default\_subnet\_cidr](#input\_public\_default\_subnet\_cidr)

Description: n/a

Type: `list(any)`

Default: `[]`

### <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway)

Description: Should be true if you want to provision a single shared NAT Gateway across all of your private networks

Type: `bool`

Default: `false`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Additional tags (e.g. `map('BusinessUnit','XYZ')`

Type: `map(string)`

Default: `{}`

### <a name="input_tgw_cidr"></a> [tgw\_cidr](#input\_tgw\_cidr)

Description: List of CIDR ranges . Defaults to 0.0.0.0/0

Type: `string`

Default: `"0.0.0.0/0"`

### <a name="input_tgw_id"></a> [tgw\_id](#input\_tgw\_id)

Description: List of CIDR ranges . Defaults to 0.0.0.0/0

Type: `string`

Default: `null`

### <a name="input_tgw_pub_cidr"></a> [tgw\_pub\_cidr](#input\_tgw\_pub\_cidr)

Description: List of CIDR ranges . Defaults to 0.0.0.0/0

Type: `string`

Default: `"0.0.0.0/0"`

### <a name="input_tgw_pub_id"></a> [tgw\_pub\_id](#input\_tgw\_pub\_id)

Description: List of CIDR ranges . Defaults to 0.0.0.0/0

Type: `string`

Default: `null`

### <a name="input_tgw_pub_route"></a> [tgw\_pub\_route](#input\_tgw\_pub\_route)

Description: Name of the document

Type: `bool`

Default: `false`

### <a name="input_tgw_route"></a> [tgw\_route](#input\_tgw\_route)

Description: Name of the document

Type: `bool`

Default: `false`

### <a name="input_vpn_gateway_id"></a> [vpn\_gateway\_id](#input\_vpn\_gateway\_id)

Description: n/a

Type: `string`

Default: `""`

## Outputs

The following outputs are exported:

### <a name="output_all_subnets"></a> [all\_subnets](#output\_all\_subnets)

Description: n/a

### <a name="output_nat_gatway_ids"></a> [nat\_gatway\_ids](#output\_nat\_gatway\_ids)

Description: n/a

### <a name="output_route_tables_private_app"></a> [route\_tables\_private\_app](#output\_route\_tables\_private\_app)

Description: n/a

### <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block)

Description: n/a

### <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id)

Description: n/a

### <a name="output_vpc_private_subnets_app"></a> [vpc\_private\_subnets\_app](#output\_vpc\_private\_subnets\_app)

Description: n/a

### <a name="output_vpc_private_subnets_db"></a> [vpc\_private\_subnets\_db](#output\_vpc\_private\_subnets\_db)

Description: n/a

### <a name="output_vpc_public_subnets"></a> [vpc\_public\_subnets](#output\_vpc\_public\_subnets)

Description: n/a
