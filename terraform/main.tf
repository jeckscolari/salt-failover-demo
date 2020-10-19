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

module "ec2" {
  source            = "./modules/ec2"
  tag_prj           = var.tag_prj
  instance_type     = "t2.micro"
  security_group_id = module.network.vpc_security_group_id

  ec2_settings = {
    "active-ws"  = { 
      subnet = values(module.network.public_subnet_ids)[0], 
      user_data = file("./scripts/active_webserver.sh") 
    }
    "passive-ws" = { 
      subnet = values(module.network.public_subnet_ids)[1], 
      user_data = file("./scripts/passive_webserver.sh") 
    }
  }

  depends_on = [module.network]
}