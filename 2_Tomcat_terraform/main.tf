# AWS create infrastructure with existing module

provider "aws" {
  region = "eu-central-1"
}

module "name_module_myapp_webserver" {
  source                     = "./modules/webserver"
  ws_vpc_id                  = module.vpc.vpc_id #use id from module vpc
  ws_my_ip                   = var.main_my_ip
  ws_env_prefix              = var.main_env_prefix
  ws_webserver_image_name    = var.main_image_name
  ws_my_publick_key_location = var.main_my_publick_key_location
  ws_instance_type           = var.main_instance_type
  ws_subnet_id               = module.vpc.public_subnets[0] #it back array of values but use subnet id from module vpc
  ws_avail_zone              = var.main_avail_zone

}

module "vpc" {                              #use external module from https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source  = "terraform-aws-modules/vpc/aws" #link to online repo
  version = "3.18.1"                        #if don't prescribe will download latest version

  name = "my-vpc"
  cidr = var.main_vpc_cidr_block

  azs            = [var.main_avail_zone]
  public_subnets = [var.main_subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.main_env_prefix}-subnet-1"
  }

  tags = {
    Name = "${var.main_env_prefix}-vpc"
  }
}




