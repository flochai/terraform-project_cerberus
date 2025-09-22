# Get the Availability Zones
data "aws_availability_zones" "available" {}

# Get the VPC Module 
module "vpc" {
  source                              = "terraform-aws-modules/vpc/aws"
  version                             = "~> 5.0"
  name                                = "${var.namespace}-vpc"
  cidr                                = "10.0.0.0/16"
  azs                                 = data.aws_availability_zones.available.names
  public_subnets                      = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets                    = ["10.0.201.0/24", "10.0.202.0/24"]
  create_database_subnet_group        = true
  single_nat_gateway                  = true
  create_database_subnet_route_table  = true  
  enable_nat_gateway                  = false 
}

# EC2 Security Group
resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.namespace}-allow_ssh_http"
  description = "Allow incoming SSH and HTTP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Incoming SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  description = "Incoming HTTPS"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
  ingress {
    description = "Incoming HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.namespace}-allow_ssh_pub"
  }
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name        = "${var.namespace}-rds"
  description = "Allow DB traffic from EC2 SG"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "DB access from EC2 SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ssh_pub.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.namespace}-rds" }
}

#SG for VPC internal SSH and HTTP
resource "aws_security_group" "allow_ssh_priv" {
  name        = "${var.namespace}-allow_ssh_priv"
  description = "Allow Incoming SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Internal VPC SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    description = "Internal VPC HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-allow_ssh_priv"
  }
}
