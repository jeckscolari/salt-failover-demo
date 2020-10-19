data "aws_subnet" "private_subnets" {
  for_each = var.private_subnets
  vpc_id   = var.vpc_id

  filter {
    name   = "tag:Name"
    values = [each.key]
  }
}

data "aws_subnet" "public_subnets" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = [var.public_subnets]
  }
}

resource "aws_eip" "nat_gw" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = data.aws_subnet.public_subnets.id

  tags = {
    prj = var.tag_prj
  }
}

resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  
  tags = {
    prj = var.tag_prj
  }
}

resource "aws_route_table_association" "private_subnets" {
  for_each       = data.aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main.id
}