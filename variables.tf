variable "image_id" {
  type     = string
  default  = "ami-03601e822a943105f"
  nullable = false
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "monitoring" {
  type    = bool
  default = false
}

variable "cidr_block_vpc" {
  type    = list(any)
  default = ["172.16.0.0/16"]
}

variable "cidr_block_subnet" {
  type    = list(any)
  default = ["172.16.0.0/24"]
}

variable "availability_zone" {
  type    = list(any)
  default = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "ebs_size" {
  type    = number
  default = 10
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "namespace" {
  type = string
  default = "cerberus"
}
