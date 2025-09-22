output "private_ip" {
  value = aws_instance.chimera-instance.private_ip
}

output "instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.chimera-instance.id
}

output "public_instance_az" {
  description = "AZ of the public EC2 instance"
  value       = aws_instance.chimera-instance.availability_zone
}