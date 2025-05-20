variable "region" {}

variable "availability_zones" {
  type    = list(any)
  default = []
}

variable "availability_nat" {
  type    = list(any)
  default = []
}

variable "public_default_subnet_cidr" {
  type    = list(any)
  default = []
}

variable "private_app_subnet_cidr" {
  type    = list(any)
  default = []
}

variable "private_db_subnet_cidr" {
  type    = list(any)
  default = []
}

variable "cidr_block" {
  type        = string
  description = "List of CIDR ranges . Defaults to 0.0.0.0/0"
  default     = "0.0.0.0/0"
}

variable "vpc_peering_connection_id" {
  description = "The ID of the VPC Peering Connection."
  type        = string
  default     = ""
}

variable "peer_vpc_cidr_block" {
  description = "The CIDR block of the remote peer VPC."
  type        = string
  default     = ""
}

variable "existing_public_routes" {
  description = "List of existing routes to preserve in public route tables"
  type = list(object({
    cidr_block = string
    gateway_id = string
  }))
  default = null
}

variable "existing_private_routes" {
  description = "List of existing routes to preserve in private route tables"
  type = list(object({
    cidr_block = string
    gateway_id = string
  }))
  default = null
}

variable "vpc_peering_routes" {
  description = "List of VPC peering routes"
  type = list(object({
    cidr_block                = string
    vpc_peering_connection_id = string
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "external_route_private" {
  type    = list(map(string))
  default = []
}

variable "external_route_public" {
  type    = list(map(string))
  default = []
}

variable "create_route_public" {
  description = "Whether to create routes and integrations resources"
  type        = bool
  default     = false
}

variable "create_route_private" {
  description = "Whether to create routes and integrations resources"
  type        = bool
  default     = true
}

variable "propagate_private_route_tables_vgw" {
  description = "Whether to create routes and integrations resources"
  type        = list(string)
  default     = []
}

variable "vpn_gateway_id" {
  type    = string
  default = ""
}

variable "tgw_route" {
  description = "Name of the document"
  type        = bool
  default     = false
}

variable "tgw_cidr" {
  type        = string
  description = "List of CIDR ranges . Defaults to 0.0.0.0/0"
  default     = "0.0.0.0/0"
}

variable "tgw_id" {
  type        = string
  description = "List of CIDR ranges . Defaults to 0.0.0.0/0"
  default     = null
}

variable "tgw_pub_route" {
  description = "Name of the document"
  type        = bool
  default     = false
}


variable "tgw_pub_cidr" {
  type        = string
  description = "List of CIDR ranges . Defaults to 0.0.0.0/0"
  default     = "0.0.0.0/0"
}

variable "tgw_pub_id" {
  type        = string
  description = "List of CIDR ranges . Defaults to 0.0.0.0/0"
  default     = null
}

variable "manage_default_network_acl" {
  description = "Should be true to adopt and manage Default Network ACL"
  type        = bool
  default     = false
}

variable "default_network_acl_ingress" {
  description = "List of maps of ingress rules to set on the Default Network ACL"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_network_acl_egress" {
  description = "List of maps of egress rules to set on the Default Network ACL"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}