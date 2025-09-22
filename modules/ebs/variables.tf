variable "availability_zone" {
  description = "AZ where the EBS volume will be created"
  type        = string
}

variable "ebs_size" {
  description = "Size of the EBS volume in GiB"
  type        = number
}

variable "instance_id" {
  description = "EC2 instance ID to attach the EBS volume to"
  type        = string
}
