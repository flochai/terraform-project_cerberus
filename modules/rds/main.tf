resource "aws_db_instance" "cerberus_db" {
  identifier             = "cerberus-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "mariadb"
  engine_version         = "10.11"
  username               = "cerberus1"
  password               = var.db_password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.sg_priv_id]
  publicly_accessible    = true
  skip_final_snapshot    = true
  multi_az               = true
}

