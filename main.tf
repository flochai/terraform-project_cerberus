provider "aws" {
  region = "eu-west-3"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}
# Networking Module Call
module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

# EC2 Module Call
module "ec2" {
  source      = "./modules/ec2"
  namespace   = var.namespace
  vpc         = module.networking.vpc
  sg_pub_id   = module.networking.sg_pub_id
  sg_priv_id  = module.networking.sg_priv_id
  key_name    = "chimera-key"
  db_password = var.db_password
  db_host     = module.rds.address
  
}

#EBS Module Call
module "ebs" {
  source            = "./modules/ebs"
  ebs_size          = var.ebs_size
  availability_zone = module.ec2.public_instance_az
  instance_id       = module.ec2.instance_id
}

#RDS Module Call
module "rds" {
  source               = "./modules/rds"
  namespace            = var.namespace
  vpc                  = module.networking.vpc
  db_subnet_group_name = module.networking.db_subnet_group_name
  sg_pub_id            = module.networking.sg_rds_id
  sg_priv_id           = module.networking.sg_rds_id
  db_password          = var.db_password
}