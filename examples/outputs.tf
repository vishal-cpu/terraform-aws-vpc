output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private app subnets"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private DB subnets"
  value       = module.vpc.private_db_subnet_ids
}

output "nat_gateway_ips" {
  description = "EIPs of the NAT gateways"
  value       = module.vpc.nat_gateway_ips
}