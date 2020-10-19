data "aws_subnet" "public_subnets" {
  for_each = var.public_subnets
  vpc_id   = var.vpc_id
  
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    prj  = var.tag_prj
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    prj = var.tag_prj
  }
}

resource "aws_route_table_association" "public_subnets" {
  for_each       = data.aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_table.id
}