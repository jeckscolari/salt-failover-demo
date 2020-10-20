provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_key_pair" "id_rsa_aws" {
  key_name   = "id_rsa_aws"
  public_key = file(var.public_key_path)
}

module "vpc" {
  source = "./modules/vpc"

  tag_prj    = var.tag_prj
  aws_region = var.aws_region
  my_ip      = var.my_ip
}

module "salt_master" {
  source = "./modules/salt-master"

  tag_prj             = var.tag_prj
  vpc_security_group  = module.vpc.security_group_id
  vpc_private_subnets = module.vpc.private_subnets
  key_pair_name       = aws_key_pair.id_rsa_aws.key_name
}

module "webserver" {
  source = "./modules/webserver"

  tag_prj            = var.tag_prj
  vpc_security_group = module.vpc.security_group_id
  vpc_public_subnets = module.vpc.public_subnets
  key_pair_name      = aws_key_pair.id_rsa_aws.key_name
  salt_masters       = module.salt_master.private_ip
}
