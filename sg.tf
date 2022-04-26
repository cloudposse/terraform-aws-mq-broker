module "security_group" {
  source  = "cloudposse/security-group/aws"
  version = "0.4.3"

  enabled                       = local.security_group_enabled
  security_group_name           = var.security_group_name
  create_before_destroy         = var.security_group_create_before_destroy
  security_group_create_timeout = var.security_group_create_timeout
  security_group_delete_timeout = var.security_group_delete_timeout

  security_group_description = var.security_group_description
  allow_all_egress           = true
  rules                      = var.additional_security_group_rules
  vpc_id                     = var.vpc_id

  context = module.this.context
}
