variable "aws_access_key" {}

variable "aws_secret_key" {}

variable aws_region {
  default = "eu-central-1"
}

variable "tag_prj" {
  default = "salt-failover-demo"
}

variable "my_ip" {}