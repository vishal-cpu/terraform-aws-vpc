output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "vpc_public_subnets" {
  value = aws_subnet.public_default.*.id
}

output "vpc_private_subnets_app" {
  value = aws_subnet.private_app.*.id
}

output "vpc_private_subnets_db" {
  value = aws_subnet.private_db.*.id
}

output "nat_gatway_ids" {
  value = aws_nat_gateway.ngw.*.id
}

output "all_subnets" {
  value = concat(aws_subnet.private_app.*.id, aws_subnet.public_default.*.id, aws_subnet.private_db.*.id)
}

output "route_tables_private_app" {
  value = aws_route_table.private_app.*.id
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