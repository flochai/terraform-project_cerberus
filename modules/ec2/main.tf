data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
# Create Instance
resource "aws_instance" "chimera-instance" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.vpc.public_subnets[0]
  vpc_security_group_ids      = [var.sg_pub_id]
  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    export DB_HOST="${var.db_host}"    
    export DB_NAME="chimera_db"
    export DB_USER="chimera1"
    export DB_PASSWORD="${var.db_password}"

    # run the root script
    ${file("${path.root}/install_wordpress.sh")}
    EOF

  user_data_replace_on_change = true

  tags = {
    "Name" = "${var.namespace}-EC2-PUBLIC"
  }
}
