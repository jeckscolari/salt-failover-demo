module "webserver" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "${var.tag_prj}-webserver"
  instance_count = 2

  ami                         = data.aws_ami.aws_linux.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [var.vpc_security_group]
  subnet_ids                  = var.vpc_public_subnets
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  user_data = templatefile("${path.module}/user_data.sh", {
    salt_masters : var.salt_masters
  })

  tags = {
    Terraform = "true"
    Project   = var.tag_prj
  }
}
