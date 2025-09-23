output "address" {
  description = "RDS instance hostname"
  value       = aws_db_instance.cerberus_db.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.cerberus_db.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.cerberus_db.username
  sensitive   = true
}
