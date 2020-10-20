module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.tag_prj}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.0.0/24"] #, "10.0.1.0/24"]
  public_subnets  = ["10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false

  manage_default_security_group = true
  default_security_group_egress = [{
    from_port : 0
    to_port : 0
    protocol : -1
    cidr_blocks : "0.0.0.0/0"
  }]
  default_security_group_ingress = [{
    from_port : 0
    to_port : 0
    protocol : -1
    self : true
    },
    {
      from_port : 22
      to_port : 22
      protocol : "TCP"
      cidr_blocks : "${var.my_ip}/32"
    },
    {
      from_port : 80
      to_port : 80
      protocol : "TCP"
      cidr_blocks : "0.0.0.0/0"
  }]
  default_security_group_name = "${var.tag_prj}-sg"
  default_security_group_tags = {
    Terraform = "true"
    Project   = var.tag_prj
  }

  tags = {
    Terraform = "true"
    Project   = var.tag_prj
  }
}

# resource "aws_security_group" "security_group" {
#   vpc_id      = module.vpc.vpc_id
#   name        = "${var.tag_prj}-sg"
#   description = "Allows all traffic within VPC, SSH from single IP and HTTP from Internet"

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = -1
#     self      = true
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "TCP"
#     cidr_blocks = ["${var.my_ip}/32"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Terraform = "true"
#     Project   = var.tag_prj
#   }
# }

