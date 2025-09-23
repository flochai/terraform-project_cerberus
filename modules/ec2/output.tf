output "private_ip" {
  value = aws_instance.cerberus-instance.private_ip
}

output "instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.cerberus-instance.id
}

output "public_instance_az" {
  description = "AZ of the public EC2 instance"
  value       = aws_instance.cerberus-instance.availability_zone
}
