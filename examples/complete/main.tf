provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.18.1"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.33.1"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "mq_broker" {
  source = "../../"

  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.subnets.private_subnet_ids
  allowed_security_groups = [module.vpc.vpc_default_security_group_id]

  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  deployment_mode              = var.deployment_mode
  engine_type                  = var.engine_type
  engine_version               = var.engine_version
  host_instance_type           = var.host_instance_type
  publicly_accessible          = var.publicly_accessible
  general_log_enabled          = var.general_log_enabled
  audit_log_enabled            = var.audit_log_enabled
  use_existing_security_groups = var.use_existing_security_groups
  kms_ssm_key_arn              = var.kms_ssm_key_arn
  encryption_enabled           = var.encryption_enabled
  kms_mq_key_arn               = var.kms_mq_key_arn
  use_aws_owned_key            = var.use_aws_owned_key

  context = module.this.context
}
