data "aws_ami" "aws_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2" {
  for_each               = var.ec2_settings
  ami                    = data.aws_ami.aws_linux.id
  instance_type          = var.instance_type
  subnet_id              = each.value.subnet
  vpc_security_group_ids = [var.security_group_id]
  user_data              = each.value.user_data

  tags = {
    prj  = var.tag_prj
    Name = "${var.tag_prj}-${each.key}"
  }
}