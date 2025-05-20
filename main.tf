######
# VPC
######
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = merge(var.tags, {
    "Name" = "vpc"
  })
}

###########
# GATEWAYS
###########
resource "aws_internet_gateway" "igw" {
  depends_on = [aws_vpc.main]
  vpc_id     = aws_vpc.main.id
  tags = merge(var.tags, {
    "Name" = "igw"
  })
}

resource "aws_eip" "nat" {
  depends_on = [aws_vpc.main]
  count      = var.single_nat_gateway ? 1 : length(var.availability_zones)

  lifecycle { create_before_destroy = true }

  tags = merge(var.tags, {
    "Name" = "eip-${element(var.availability_zones, var.single_nat_gateway ? 0 : count.index)}-natgw"
  })
}

resource "aws_nat_gateway" "ngw" {
  count = var.single_nat_gateway ? 1 : length(var.availability_zones)
  allocation_id = element(
    aws_eip.nat.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    aws_subnet.public_default.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )

  tags = merge(var.tags, {
    "Name" = "ngw-${element(var.availability_zones, var.single_nat_gateway ? 0 : count.index)}"
  })

  depends_on = [aws_internet_gateway.igw]
}

##########
# SUBNETS
##########
resource "aws_subnet" "public_default" {
  depends_on              = [aws_vpc.main]
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_default_subnet_cidr)
  cidr_block              = element(var.public_default_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    "Name" = "subnet-public-default-${element(var.availability_zones, count.index)}",
  })
}

resource "aws_subnet" "private_app" {
  depends_on              = [aws_vpc.main]
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_app_subnet_cidr)
  cidr_block              = element(var.private_app_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    "Name" = "subnet-private-app-${element(var.availability_zones, count.index)}",
  })
}

resource "aws_subnet" "private_db" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_db_subnet_cidr)
  cidr_block              = element(var.private_db_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    "Name" = "subnet-private-db-${element(var.availability_zones, count.index)}"
  })
}


###############
# ROUTE TABLES
###############
resource "aws_route_table" "public_default" {
  count  = var.single_nat_gateway ? 1 : length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.existing_public_routes != null ? var.existing_public_routes : []
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  #route {
  #  cidr_block         = var.tgw_pub_cidr
  #  transit_gateway_id = var.tgw_pub_id
  #}

  dynamic "route" {
    for_each = var.create_route_public ? var.external_route_public : []
    content {
      cidr_block = lookup(route.value, "cidr_block", "null")
      gateway_id = lookup(route.value, "gateway_id", "null")
    }
  }

  dynamic "route" {
    for_each = var.vpc_peering_routes != null && length(var.vpc_peering_routes) > 0 ? var.vpc_peering_routes : []
    content {
      cidr_block                = route.value.cidr_block
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }

  depends_on = [aws_internet_gateway.igw]

  tags = merge(var.tags, {
    "Name" = "route-public-default-${var.single_nat_gateway ? element(var.availability_zones, 0) : element(var.availability_zones, count.index)}"
  })
}

resource "aws_route_table" "private_app" {
  count            = var.single_nat_gateway ? 1 : length(var.availability_zones)
  vpc_id           = aws_vpc.main.id
  propagating_vgws = var.propagate_private_route_tables_vgw

  dynamic "route" {
    for_each = var.existing_private_routes != null ? var.existing_private_routes : []
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.ngw[0].id
  # }

  # route {
  #   cidr_block         = var.tgw_cidr
  #   transit_gateway_id = var.tgw_id
  # }

  dynamic "route" {
    for_each = var.create_route_private ? var.external_route_private : []
    content {
      cidr_block = lookup(route.value, "cidr_block", "null")
      gateway_id = lookup(route.value, "gateway_id", "null")
    }
  }

  depends_on = [aws_nat_gateway.ngw]

  tags = merge(var.tags, {
    "Name" = "route-private-app-${var.single_nat_gateway ? element(var.availability_zones, 0) : element(var.availability_zones, count.index)}"
  })
}

resource "aws_route_table" "private_db" {
  count            = var.single_nat_gateway && var.tgw_route ? 1 : length(var.private_db_subnet_cidr)
  vpc_id           = aws_vpc.main.id
  propagating_vgws = var.propagate_private_route_tables_vgw

  dynamic "route" {
    for_each = var.existing_private_routes != null ? var.existing_private_routes : []
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }

  route {
    cidr_block         = var.tgw_cidr
    transit_gateway_id = var.tgw_id
  }

  dynamic "route" {
    for_each = var.create_route_private ? var.external_route_private : []
    content {
      cidr_block = lookup(route.value, "cidr_block", "null")
      gateway_id = lookup(route.value, "gateway_id", "null")
    }
  }

  depends_on = [aws_nat_gateway.ngw]

  tags = merge(var.tags, {
    "Name" = "route-private-db-${element(var.availability_zones, var.single_nat_gateway ? 0 : count.index)}"
  })
}

###########################
# ROUTE TABLE ASSOCIATIONS
###########################
resource "aws_route_table_association" "public_default" {
  count          = length(var.public_default_subnet_cidr) > 0 ? length(var.public_default_subnet_cidr) : 0
  subnet_id      = element(aws_subnet.public_default.*.id, count.index)
  route_table_id = element(aws_route_table.public_default.*.id, count.index)
}

resource "aws_route_table_association" "private_app" {
  count     = length(var.private_app_subnet_cidr) > 0 ? length(var.private_app_subnet_cidr) : 0
  subnet_id = element(aws_subnet.private_app.*.id, count.index)
  route_table_id = element(
    aws_route_table.private_app.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route_table_association" "private_db" {
  count     = length(var.private_db_subnet_cidr) > 0 ? length(var.private_db_subnet_cidr) : 0
  subnet_id = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = element(
    aws_route_table.private_db.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

################################################################################
# Default Network ACLs
################################################################################
resource "aws_default_network_acl" "this" {
  count = var.manage_default_network_acl ? 1 : 0

  default_network_acl_id = aws_vpc.main.default_network_acl_id

  # The value of subnet_ids should be any subnet IDs that are not set as subnet_ids
  # for any of the non-default network ACLs
  subnet_ids = setsubtract(
    compact(flatten([
      aws_subnet.public_default.*.id,
      aws_subnet.private_app.*.id,
      aws_subnet.private_db.*.id,
    ])),
    compact(flatten([
      # If you have defined specific network ACLs, list them here
      # aws_network_acl.public.*.subnet_ids,
      # aws_network_acl.private.*.subnet_ids,
    ]))
  )

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  tags = merge(var.tags, {
    "Name" = "vpc-nacl"
  })
}