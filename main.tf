terraform {
  # backend "s3" {
  #   bucket = "" 
  #   key    = "tf/terraform.tfstate"
  # }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Region  = var.aws_region
      Role    = var.role
      Project = var.project
      Owner   = var.owner_email
    }
  }
}
module "vpc" {
  source              = "./modules/vpc"
  cidr                = "10.0.0.0/16"
  private_subnet_cidr = "10.0.1.0/24"
  public_subnet_cidr  = "10.0.101.0/24"
  vpc_id              = module.vpc.vpc_id
  private_subnet_id   = module.vpc.private_subnet_id
  public_subnet_id    = module.vpc.public_subnet_id
  nat_gatway_id       = module.vpc.nat_gatway_id
  igw_id              = module.vpc.igw_id
}
module "s3" {
  source              = "./modules/s3"
  public_key_location = var.public_key_location
  role                = var.role
  project             = var.project
}
output "s3" {  
  value = module.s3 
}
module "server" {
  source                       = "./modules/server"
  aws_keypair                  = var.aws_keypair
  role                         = var.role
  project                      = var.project
  public_subnet_id             = module.vpc.public_subnet_id
  private_subnet_id            = module.vpc.private_subnet_id
  server_sg_id                 = module.vpc.server_sg_id
  bastian_sg_id                = module.vpc.bastian_sg_id
  bastion_instance_profile     = module.server.bastion_instance_profile
  server_read_instance_profile = module.server.server_read_instance_profile
  server_rw_instance_profile   = module.server.server_rw_instance_profile
  team_project_bucket          = module.s3.team_project_bucket
  keystore_bucket              = module.s3.keystore_bucket
  depends_on                   = [module.s3, module.vpc]
}

output "server" {  
  value = module.server 
}
