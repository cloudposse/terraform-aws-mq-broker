module "security_group" {
  source  = "cloudposse/security-group/aws"
  version = "0.3.1"

  use_name_prefix = var.security_group_use_name_prefix
  rules           = var.security_group_rules
  vpc_id          = var.vpc_id
  description     = var.security_group_description

  enabled = local.security_group_enabled
  context = module.this.context
}
