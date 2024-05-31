provider "aws" {
  region = var.region
}

resource "aws_instance" "DATA472-jcl173-ubuntu_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnetid
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true
  key_name                    = var.instance_keypair_name
  ebs_optimized               = false
  tags = {
    Name     = var.name
    Course   = var.course
    UserName = var.username
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.volumesize
  }
  volume_tags = {
    Name     = var.name
    Course   = var.course
    UserName = var.username
  }


}
