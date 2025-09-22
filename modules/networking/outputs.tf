# Security group IDs (used by EC2 / RDS modules)
output "sg_pub_id" {
  value       = aws_security_group.allow_ssh_pub.id
  description = "Public SG ID (SSH/HTTP from the internet)"
}

output "sg_priv_id" {
  value       = aws_security_group.allow_ssh_priv.id
  description = "Private SG ID (intra-VPC SSH/HTTP)"
}

output "vpc" {
  value = {
    vpc_id          = module.vpc.vpc_id
    public_subnets  = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
  }
  description = "VPC object with ids and subnets"
}

output "db_subnet_group_name" {
  description = "DB subnet group name from the VPC module"
  value       = module.vpc.database_subnet_group_name
}

output "sg_rds_id" {
  value = aws_security_group.rds.id
}