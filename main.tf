terraform {
  required_version = ">= 1.7"
  backend "s3" {
    bucket = "succeedhq-terraform-state"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  environment = var.environment
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id     = module.vpc.id
  subnet_ids = module.vpc.private_subnet_ids
  environment = var.environment
}

module "rds" {
  source = "./modules/rds"
  vpc_id         = module.vpc.id
  subnet_ids     = module.vpc.database_subnet_ids
  instance_class = "db.t3.medium"
  environment    = var.environment
}
