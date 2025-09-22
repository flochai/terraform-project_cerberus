variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}
# Deployment Env
variable "namespace" {
  type = string
}
# VPC
variable "vpc" {
  type = any
}
# ID of Public Security Group
variable "sg_pub_id" {
  type = any
}
# ID of Private Security Group
variable "sg_priv_id" {
  type = any
}
variable "db_subnet_group_name" {
  type = string
}
