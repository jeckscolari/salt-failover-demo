module "salt_master" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "${var.tag_prj}-salt-master"
  instance_count = 1

  ami                    = data.aws_ami.aws_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.vpc_security_group]
  subnet_ids             = var.vpc_private_subnets
  key_name               = var.key_pair_name
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Terraform = "true"
    Project   = var.tag_prj
  }
}
