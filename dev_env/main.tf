#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create VPC
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "vpc" {

  source                  = "../modules/vpc"
  region                  = var.region
  project_name            = var.project_name
  vpc_cidr                = var.vpc_cidr
  public_subnet_az1_cidr  = var.public_subnet_az1_cidr
  public_subnet_az2_cidr  = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr

}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create Security Group
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "security_groups" {

  source = "../modules/security_groups"
  vpc_id = module.vpc.vpc_id

}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create key pair
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module "keypair_generator" {

  source = "../modules/keypair_generator"
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create Application load balancer
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "application_load_balancer" {
  source               = "../modules/application_load_balancer"
  project_name         = module.vpc.project_name
  alb_security_group   = module.security_groups.alb_security_group_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  vpc_id               = module.vpc.vpc_id
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create auto-scalling
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "auto_scaling" {

  source                    = "../modules/auto_scaling"
  project_name              = module.vpc.project_name
  public_subnet_az1_id      = module.vpc.public_subnet_az1_id
  public_subnet_az2_id      = module.vpc.public_subnet_az2_id
  public_ec2_security_group = module.security_groups.public_ec2_security_group_id
  key_name                  = module.keypair_generator.key_id
  min_size                  = var.min_size
  max_size                  = var.max_size
  instance_type             = var.instance_type
  target_group_arn          = module.application_load_balancer.target_group_arn
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create rds server
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "rds_server" {
  source                = "../modules/rds_server"
  project_name          = module.vpc.project_name
  private_subnet_az1_id = module.vpc.private_subnet_az1_id
  private_subnet_az2_id = module.vpc.private_subnet_az2_id
  rds_security_group_id = module.security_groups.rds_security_group_id

}
