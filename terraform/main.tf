provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


module "network" {
  source              = "./modules/network"
  tag_prj             = var.tag_prj
  region              = var.aws_region
  vpc_name            = "vpc-${var.tag_prj}"
  security_group_name = "${var.tag_prj}-sg"
  my_ip               = var.my_ip
}

module "salt_master" {
  source            = "./modules/ec2"
  tag_prj           = var.tag_prj
  instance_type     = "t2.micro"
  instance_name     = "${var.tag_prj}-salt-master"
  security_group_id = module.network.vpc_security_group_id
  subnet_id         = values(module.network.private_subnet_ids)[0]
  user_data         = file("./scripts/salt_master.sh")
  depends_on        = [module.network]
}

data "template_file" "active_webserver" {
  template = file("./scripts/active_webserver.sh")
  vars = {
    salt_master = module.salt_master.instance_private_ip
  }
}

module "active_webserver" {
  source            = "./modules/ec2"
  tag_prj           = var.tag_prj
  instance_type     = "t2.micro"
  instance_name     = "${var.tag_prj}-active-ws"
  security_group_id = module.network.vpc_security_group_id
  subnet_id         = values(module.network.public_subnet_ids)[0]
  user_data         = data.template_file.active_webserver.rendered
  depends_on        = [module.salt_master]
}

data "template_file" "passive_webserver" {
  template = file("./scripts/passive_webserver.sh")
  vars = {
    salt_master = module.salt_master.instance_private_ip
  }
}

module "passive_webserver" {
  source            = "./modules/ec2"
  tag_prj           = var.tag_prj
  instance_type     = "t2.micro"
  instance_name     = "${var.tag_prj}-passive-ws"
  security_group_id = module.network.vpc_security_group_id
  subnet_id         = values(module.network.public_subnet_ids)[1]
  user_data         = data.template_file.passive_webserver.rendered
  depends_on        = [module.salt_master]
}