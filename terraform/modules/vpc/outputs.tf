output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "security_group_id" {
  value = module.vpc.default_security_group_id
}
