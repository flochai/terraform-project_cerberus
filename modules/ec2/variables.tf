# Deployment Env
variable "namespace" {
  type = string
}
# VPC
variable "vpc" {
  type = any
}
# Key Pair
variable "key_name" {
  type = string
}
# ID of Public Security Group
variable "sg_pub_id" {
  type = any
}
# ID of Private Security Group
variable "sg_priv_id" {
  type = any
}

variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_host" {
  type = string
}
