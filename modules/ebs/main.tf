resource "aws_ebs_volume" "chimera_ebs" {
  availability_zone = var.availability_zone
  size              = var.ebs_size

  tags = { Name = "chimera-ebs" }
}

resource "aws_volume_attachment" "chimera_ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.chimera_ebs.id
  instance_id = var.instance_id
}