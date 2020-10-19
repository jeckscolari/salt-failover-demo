resource "aws_security_group" "security_group" {
  name        = var.security_group_name
  description = "Allows all traffic within VPC"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    prj = var.tag_prj
  }
}