resource "aws_vpc" "vpc" {
  cidr_block           = var.base_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    prj  = var.tag_prj
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.key
  availability_zone = each.value

  tags = {
    Name = "private-subnet-${var.vpc_name}-${each.key}"
    prj  = var.tag_prj
  }
}

resource "aws_subnet" "public_subnet" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.key
  availability_zone       = each.value
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet-${var.vpc_name}-${each.key}"
    prj  = var.tag_prj
  }
}