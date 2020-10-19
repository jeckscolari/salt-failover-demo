module "vpc" {
  source          = "./vpc"
  tag_prj         = var.tag_prj
  vpc_name        = var.vpc_name
  base_cidr_block = var.base_cidr_block
  
  public_subnets = {
    "10.0.2.0/24" = "${var.region}a"
    "10.0.3.0/24" = "${var.region}b"
  }
  
  private_subnets = {
    "10.0.0.0/24" = "${var.region}a"
    "10.0.1.0/24" = "${var.region}b"
  }
}

module "security_group" {
  source              = "./security_group"
  tag_prj             = var.tag_prj
  vpc_id              = module.vpc.vpc_id
  security_group_name = var.security_group_name
  base_cidr_block     = var.base_cidr_block
  my_ip               = var.my_ip
  depends_on          = [module.vpc]
}

module "internet_gateway" {
  source  = "./internet_gateway"
  tag_prj = var.tag_prj
  vpc_id  = module.vpc.vpc_id

  public_subnets = {
    "public-subnet-${var.vpc_name}-10.0.2.0/24" = "${var.region}a"
    "public-subnet-${var.vpc_name}-10.0.3.0/24" = "${var.region}b"
  }

  depends_on = [module.vpc]
}

module "nat_gateway" {
  source  = "./nat_gateway"
  tag_prj = var.tag_prj
  vpc_id  = module.vpc.vpc_id

  private_subnets = {
    "private-subnet-${var.vpc_name}-10.0.0.0/24" = "${var.region}a"
    "private-subnet-${var.vpc_name}-10.0.1.0/24" = "${var.region}b"
  }

  public_subnets = "public-subnet-${var.vpc_name}-10.0.2.0/24"

  depends_on = [module.internet_gateway]
}